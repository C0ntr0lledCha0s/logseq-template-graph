#!/usr/bin/env bb

;; Logseq Template Builder
;; Merges modular source files into compiled EDN templates

(require '[clojure.edn :as edn]
         '[clojure.java.io :as io]
         '[clojure.string :as str]
         '[clojure.pprint :refer [pprint]])

(def COLORS
  {:green "\033[0;32m"
   :yellow "\033[1;33m"
   :cyan "\033[0;36m"
   :red "\033[0;31m"
   :reset "\033[0m"})

(defn colorize [color text]
  (str (COLORS color) text (COLORS :reset)))

(defn read-edn-file [path]
  "Read and parse EDN file"
  (-> path slurp edn/read-string))

(defn find-edn-files [dir pattern]
  "Find all EDN files matching pattern recursively"
  (->> (file-seq (io/file dir))
       (filter #(and (.isFile %)
                     (re-find pattern (.getName %))
                     (str/ends-with? (.getName %) ".edn")))
       (map str)))

(defn load-preset [preset-name]
  "Load preset configuration or return default"
  (let [preset-file (str "source/presets/" preset-name ".edn")]
    (if (.exists (io/file preset-file))
      (do
        (println (colorize :yellow (str "📋 Loading preset: " preset-name)))
        (read-edn-file preset-file))
      (do
        (println (colorize :yellow "📋 Using default preset (all modules)"))
        {:name "Default"
         :description "All modules"
         :include nil}))))

(defn should-include? [module-path include-list]
  "Check if module should be included based on preset"
  (if (nil? include-list)
    true  ; Include all if no filter specified
    (some #(str/includes? module-path %) include-list)))

(defn merge-modules [modules]
  "Deep merge all module EDN files"
  (println (colorize :cyan "\n🔨 Merging modules..."))
  (reduce
    (fn [acc module-file]
      (println (colorize :green (str "  ✅ " module-file)))
      (let [module-data (read-edn-file module-file)]
        (merge-with merge acc module-data)))
    {}
    modules))

(defn build-template [preset-name output-file]
  "Build template from preset"
  (println (colorize :cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
  (println (colorize :cyan "BUILDING LOGSEQ TEMPLATE"))
  (println (colorize :cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"))

  (let [preset-config (load-preset preset-name)
        include-list (:include preset-config)

        ;; Find all module files
        _ (println (colorize :cyan "\n📦 Discovering modules..."))
        all-properties (find-edn-files "source" #"properties\.edn")
        all-classes (find-edn-files "source" #"classes\.edn")

        ;; Filter based on preset
        selected-properties (filter #(should-include? % include-list) all-properties)
        selected-classes (filter #(should-include? % include-list) all-classes)
        selected-modules (concat selected-properties selected-classes)

        _ (println (colorize :yellow (str "  Found: "
                                          (count selected-properties) " property modules, "
                                          (count selected-classes) " class modules")))

        ;; Merge all modules
        merged (merge-modules selected-modules)

        ;; Add export marker
        template (assoc merged
                   :logseq.db.sqlite.export/export-type
                   :graph-ontology)

        ;; Statistics
        prop-count (count (:properties template))
        class-count (count (:classes template))]

    ;; Write output
    (println (colorize :cyan "\n💾 Writing output..."))
    (io/make-parents output-file)
    (spit output-file (with-out-str (pprint template)))
    (println (colorize :green (str "  ✅ " output-file)))

    ;; Report
    (println (colorize :cyan "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
    (println (colorize :cyan "BUILD COMPLETE"))
    (println (colorize :cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
    (println (colorize :green (str "\n✅ Template: " (:name preset-config))))
    (println (colorize :yellow (str "📊 Properties: " prop-count)))
    (println (colorize :yellow (str "📊 Classes: " class-count)))
    (println (colorize :yellow (str "📊 Total Lines: "
                                    (with-open [rdr (io/reader output-file)]
                                      (count (line-seq rdr))))))

    (println (colorize :yellow "\n💡 Next steps:"))
    (println (str "  1. Validate: ./scripts/validate.sh " output-file))
    (println (str "  2. Test import in Logseq"))
    (println (str "  3. Compare with original if needed"))))

;; CLI
(let [[preset output] *command-line-args*
      preset (or preset "full")
      output (or output (str "build/logseq_db_Templates_" preset ".edn"))]

  (if (.exists (io/file "source"))
    (build-template preset output)
    (do
      (println (colorize :red "❌ Error: source/ directory not found"))
      (println (colorize :yellow "\n💡 Did you run scripts/split.clj first?"))
      (System/exit 1))))
