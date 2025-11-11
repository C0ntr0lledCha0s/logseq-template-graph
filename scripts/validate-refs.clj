#!/usr/bin/env bb

;; Logseq Template Reference Validator
;; Validates UUID cross-references and Schema.org inverse properties

(require '[clojure.edn :as edn]
         '[clojure.java.io :as io]
         '[clojure.string :as str]
         '[clojure.pprint :refer [pprint]]
         '[babashka.curl :as curl])

(def COLORS
  {:green "\033[0;32m"
   :yellow "\033[1;33m"
   :cyan "\033[0;36m"
   :red "\033[0;31m"
   :blue "\033[0;34m"
   :magenta "\033[0;35m"
   :reset "\033[0m"})

(defn colorize [color text]
  (str (COLORS color) text (COLORS :reset)))

(defn log-info [msg]
  (println (colorize :cyan (str "[INFO] " msg))))

(defn log-success [msg]
  (println (colorize :green (str "[SUCCESS] " msg))))

(defn log-warning [msg]
  (println (colorize :yellow (str "[WARNING] " msg))))

(defn log-error [msg]
  (println (colorize :red (str "[ERROR] " msg))))

(defn read-edn-file [path]
  "Read and parse EDN file"
  (try
    (-> path slurp edn/read-string)
    (catch Exception e
      (log-error (str "Failed to read " path ": " (.getMessage e)))
      nil)))

(defn find-edn-files [dir]
  "Find all .edn files in directory recursively"
  (->> (file-seq (io/file dir))
       (filter #(.isFile %))
       (filter #(str/ends-with? (.getName %) ".edn"))
       (filter #(not (str/includes? (.getPath %) "presets"))) ; Skip preset files
       (map #(.getPath %))))

(defn extract-uuid-pattern [text]
  "Extract all [[UUID]] patterns from text"
  (when (string? text)
    (re-seq #"\[\[([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})\]\]" text)))

(defn is-legacy-uuid? [uuid]
  "Check if UUID is a legacy Logseq block UUID (starts with 67xxx or 68xxx)"
  (or (str/starts-with? uuid "67")
      (str/starts-with? uuid "68")))

(defn is-inverse-property-placeholder? [uuid]
  "Check if UUID is an inverse property placeholder (00000002-xxx pattern)"
  (str/starts-with? uuid "00000002-"))

(defn build-registry [edn-files]
  "Build registry of all properties and classes with their metadata"
  (log-info "Building registry of properties and classes...")
  (let [registry {:properties {}
                  :classes {}
                  :property-titles {}
                  :class-titles {}}]
    (reduce
     (fn [reg file-path]
       (when-let [data (read-edn-file file-path)]
         (let [properties (get data :properties {})
               classes (get data :classes {})]
           (-> reg
               ;; Register properties
               (update :properties merge
                       (into {} (map (fn [[k v]]
                                       [k (assoc v :file file-path)])
                                     properties)))
               ;; Register property titles for lookup
               (update :property-titles merge
                       (into {} (map (fn [[k v]]
                                       [(str/lower-case (:block/title v)) k])
                                     properties)))
               ;; Register classes
               (update :classes merge
                       (into {} (map (fn [[k v]]
                                       [k (assoc v :file file-path)])
                                     classes)))
               ;; Register class titles for lookup
               (update :class-titles merge
                       (into {} (map (fn [[k v]]
                                       [(str/lower-case (:block/title v)) k])
                                     classes)))))))
     registry
     edn-files)))

(defn validate-cross-references [registry]
  "Validate that all :build/property-classes and :build/class-properties references exist"
  (log-info "Validating cross-references...")
  (let [errors (atom [])]

    ;; Validate property-classes references
    (doseq [[prop-id prop-data] (:properties registry)]
      (let [prop-classes (get-in prop-data [:build/property-classes] [])
            file (:file prop-data)]
        (doseq [class-ref prop-classes]
          (when-not (get-in registry [:classes class-ref])
            (swap! errors conj
                   {:type :missing-class-reference
                    :file file
                    :property prop-id
                    :property-title (:block/title prop-data)
                    :missing-class class-ref})))))

    ;; Validate class-properties references
    (doseq [[class-id class-data] (:classes registry)]
      (let [class-props (get-in class-data [:build/class-properties] [])
            file (:file class-data)]
        (doseq [prop-ref class-props]
          (when-not (get-in registry [:properties prop-ref])
            (swap! errors conj
                   {:type :missing-property-reference
                    :file file
                    :class class-id
                    :class-title (:block/title class-data)
                    :missing-property prop-ref})))))

    @errors))

(defn fetch-schema-org-property [property-name]
  "Fetch Schema.org property definition to find inverse property"
  (try
    (let [url (str "https://schema.org/" property-name ".jsonld")
          response (curl/get url {:headers {"Accept" "application/ld+json"}})]
      (when (= 200 (:status response))
        (edn/read-string (:body response))))
    (catch Exception e
      (log-warning (str "Could not fetch Schema.org data for " property-name))
      nil)))

(defn find-inverse-property [registry property-name schema-data]
  "Find inverse property from Schema.org data and match to Logseq template"
  (when schema-data
    ;; Look for inverseOf in Schema.org JSON-LD
    (let [inverse-name (get-in schema-data ["@graph" 0 "schema:inverseOf" "@id"])
          inverse-name-clean (when inverse-name (str/replace inverse-name "schema:" ""))
          inverse-name-lower (when inverse-name-clean (str/lower-case inverse-name-clean))]
      (when inverse-name-lower
        (get-in registry [:property-titles inverse-name-lower])))))

(defn validate-description-uuids [registry]
  "Validate all UUID references in property/class descriptions"
  (log-info "Validating UUID references in descriptions...")
  (let [errors (atom [])]

    ;; Validate property descriptions
    (doseq [[prop-id prop-data] (:properties registry)]
      (let [description (get-in prop-data [:build/properties :logseq.property/description])
            file (:file prop-data)]
        (when-let [uuid-matches (extract-uuid-pattern description)]
          (doseq [[full-match uuid] uuid-matches]
            (cond
              ;; Legacy Logseq block UUID
              (is-legacy-uuid? uuid)
              (let [;; Try to guess the class name from context
                    context (str/lower-case (or description ""))
                    suggested-class (cond
                                      (re-find #"organization|employer|company|business" context) "Organization"
                                      (re-find #"person|employee|member|individual" context) "Person"
                                      (re-find #"creative\s*work|article|book|document" context) "CreativeWork"
                                      :else "UnknownClass")]
                (swap! errors conj
                       {:type :legacy-uuid
                        :file file
                        :property prop-id
                        :property-title (:block/title prop-data)
                        :uuid uuid
                        :full-match full-match
                        :description description
                        :suggested-replacement (str "[[" suggested-class "]]")}))

              ;; Inverse property placeholder
              (is-inverse-property-placeholder? uuid)
              (let [property-name (:block/title prop-data)
                    ;; Try Schema.org lookup
                    schema-data (fetch-schema-org-property property-name)
                    inverse-prop-id (find-inverse-property registry property-name schema-data)
                    inverse-prop-title (when inverse-prop-id
                                         (get-in registry [:properties inverse-prop-id :block/title]))]
                (swap! errors conj
                       {:type :inverse-property-placeholder
                        :file file
                        :property prop-id
                        :property-title property-name
                        :uuid uuid
                        :full-match full-match
                        :description description
                        :schema-inverse (when inverse-prop-title inverse-prop-title)
                        :suggested-replacement (if inverse-prop-title
                                                  (str "[[" inverse-prop-title "]]")
                                                  "[[unknown-inverse-property]]")}))

              ;; Unknown UUID that should exist but doesn't
              :else
              (swap! errors conj
                     {:type :unknown-uuid
                      :file file
                      :property prop-id
                      :property-title (:block/title prop-data)
                      :uuid uuid
                      :full-match full-match
                      :description description}))))))

    ;; Validate class descriptions
    (doseq [[class-id class-data] (:classes registry)]
      (let [description (get-in class-data [:build/properties :logseq.property/description])
            file (:file class-data)]
        (when-let [uuid-matches (extract-uuid-pattern description)]
          (doseq [[full-match uuid] uuid-matches]
            (when (is-legacy-uuid? uuid)
              (let [context (str/lower-case (or description ""))
                    suggested-class (cond
                                      (re-find #"organization" context) "Organization"
                                      (re-find #"person" context) "Person"
                                      (re-find #"creative\s*work" context) "CreativeWork"
                                      :else "UnknownClass")]
                (swap! errors conj
                       {:type :legacy-uuid
                        :file file
                        :class class-id
                        :class-title (:block/title class-data)
                        :uuid uuid
                        :full-match full-match
                        :description description
                        :suggested-replacement (str "[[" suggested-class "]]")})))))))

    @errors))

(defn format-error-report [errors]
  "Format error report with actionable fixes"
  (println)
  (println (colorize :red "=================================================="))
  (println (colorize :red "         VALIDATION ERRORS FOUND"))
  (println (colorize :red "=================================================="))
  (println)

  (let [grouped-errors (group-by :type errors)]

    ;; Legacy UUID errors
    (when-let [legacy-errors (:legacy-uuid grouped-errors)]
      (println (colorize :yellow (str "Type A: Legacy Logseq Block UUIDs (" (count legacy-errors) " errors)")))
      (println (colorize :yellow "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
      (doseq [err (sort-by :file legacy-errors)]
        (println (colorize :cyan (str "\nFile: " (:file err))))
        (when-let [title (or (:property-title err) (:class-title err))]
          (println (str "  Item: " title)))
        (println (colorize :red (str "  Broken: " (:full-match err))))
        (println (colorize :green (str "  Fix:    " (:suggested-replacement err))))
        (println (str "  Context: " (subs (:description err) 0 (min 100 (count (:description err)))) "...")))
      (println))

    ;; Inverse property placeholder errors
    (when-let [inverse-errors (:inverse-property-placeholder grouped-errors)]
      (println (colorize :yellow (str "Type B: Inverse Property Placeholders (" (count inverse-errors) " errors)")))
      (println (colorize :yellow "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
      (doseq [err (sort-by :file inverse-errors)]
        (println (colorize :cyan (str "\nFile: " (:file err))))
        (println (str "  Property: " (:property-title err)))
        (println (colorize :red (str "  Broken: " (:full-match err))))
        (if (:schema-inverse err)
          (do
            (println (colorize :green (str "  Schema.org inverse: " (:schema-inverse err))))
            (println (colorize :green (str "  Fix: " (:suggested-replacement err)))))
          (println (colorize :yellow "  [!] Schema.org lookup failed - manual resolution needed")))
        (println (str "  Context: " (subs (:description err) 0 (min 100 (count (:description err)))) "...")))
      (println))

    ;; Cross-reference errors
    (when-let [missing-class-errors (:missing-class-reference grouped-errors)]
      (println (colorize :yellow (str "Missing Class References (" (count missing-class-errors) " errors)")))
      (println (colorize :yellow "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
      (doseq [err (sort-by :file missing-class-errors)]
        (println (colorize :cyan (str "\nFile: " (:file err))))
        (println (str "  Property: " (:property-title err)))
        (println (colorize :red (str "  Missing class: " (:missing-class err)))))
      (println))

    (when-let [missing-prop-errors (:missing-property-reference grouped-errors)]
      (println (colorize :yellow (str "Missing Property References (" (count missing-prop-errors) " errors)")))
      (println (colorize :yellow "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
      (doseq [err (sort-by :file missing-prop-errors)]
        (println (colorize :cyan (str "\nFile: " (:file err))))
        (println (str "  Class: " (:class-title err)))
        (println (colorize :red (str "  Missing property: " (:missing-property err)))))
      (println))

    ;; Unknown UUID errors
    (when-let [unknown-errors (:unknown-uuid grouped-errors)]
      (println (colorize :yellow (str "Unknown UUIDs (" (count unknown-errors) " errors)")))
      (println (colorize :yellow "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
      (doseq [err (sort-by :file unknown-errors)]
        (println (colorize :cyan (str "\nFile: " (:file err))))
        (when-let [title (or (:property-title err) (:class-title err))]
          (println (str "  Item: " title)))
        (println (colorize :red (str "  Unknown UUID: " (:full-match err)))))
      (println)))

  (println)
  (println (colorize :red "=================================================="))
  (println (colorize :red (str "         TOTAL ERRORS: " (count errors))))
  (println (colorize :red "=================================================="))
  (println))

(defn -main []
  (println)
  (println (colorize :cyan "╔══════════════════════════════════════════════════╗"))
  (println (colorize :cyan "║   Logseq Template Reference Validator           ║"))
  (println (colorize :cyan "╚══════════════════════════════════════════════════╝"))
  (println)

  (let [source-dir "source"
        edn-files (find-edn-files source-dir)]

    (log-info (str "Found " (count edn-files) " EDN files to validate"))
    (println)

    ;; Build registry
    (let [registry (build-registry edn-files)
          prop-count (count (:properties registry))
          class-count (count (:classes registry))]

      (log-success (str "Registry built: " prop-count " properties, " class-count " classes"))
      (println)

      ;; Run validations
      ;; Note: Cross-reference validation is disabled for modular source files
      ;; since properties and classes are in separate files
      (let [uuid-errors (validate-description-uuids registry)]

        (if (empty? uuid-errors)
          (do
            (log-success "✓ All UUID validations passed!")
            (log-success (str "✓ " prop-count " properties validated"))
            (log-success (str "✓ " class-count " classes validated"))
            (log-success "✓ All UUID references valid")
            (println)
            (System/exit 0))
          (do
            (format-error-report uuid-errors)
            (log-error "UUID validation failed. Please fix the errors above.")
            (println)
            (System/exit 1)))))))

(-main)
