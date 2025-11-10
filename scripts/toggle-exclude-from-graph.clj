#!/usr/bin/env bb
;; Toggle :exclude-from-graph-view property for all properties
;; Usage: bb scripts/toggle-exclude-from-graph.clj [add|remove]

(require '[clojure.edn :as edn]
         '[clojure.java.io :as io]
         '[clojure.pprint :as pp])

(defn add-exclude-to-property
  "Add :exclude-from-graph-view true to a property's :build/properties"
  [property-map]
  (if (contains? property-map :build/properties)
    ;; If :build/properties exists, add exclude-from-graph-view to it
    (update property-map :build/properties
            (fn [props]
              (if (map? props)
                (assoc props :exclude-from-graph-view true)
                props)))
    ;; If :build/properties doesn't exist, create it with exclude-from-graph-view
    (assoc property-map :build/properties {:exclude-from-graph-view true})))

(defn remove-exclude-from-property
  "Remove :exclude-from-graph-view from a property's :build/properties"
  [property-map]
  (if (contains? property-map :build/properties)
    ;; Remove exclude-from-graph-view from :build/properties
    (update property-map :build/properties dissoc :exclude-from-graph-view)
    property-map))

(defn has-exclude?
  "Check if a property has :exclude-from-graph-view set"
  [property-map]
  (get-in property-map [:build/properties :exclude-from-graph-view]))

(defn process-properties-file
  "Process a properties EDN file and toggle exclude-from-graph-view"
  [file-path action]
  (println "Processing:" file-path)
  (let [content (slurp file-path)
        data (edn/read-string content)
        properties (:properties data)

        ;; Count properties with/without exclude
        with-exclude (count (filter #(has-exclude? (second %)) properties))
        without-exclude (- (count properties) with-exclude)

        ;; Transform based on action
        transform-fn (case action
                       :add add-exclude-to-property
                       :remove remove-exclude-from-property)

        updated-properties (into {}
                                 (map (fn [[k v]]
                                        [k (transform-fn v)])
                                      properties))

        ;; Create updated data structure
        updated-data (assoc data :properties updated-properties)]

    ;; Write back to file with *print-namespace-maps* false
    (with-open [w (io/writer file-path)]
      (binding [*out* w
                *print-namespace-maps* false]
        (pp/pprint updated-data)))

    (println "  Before:" with-exclude "with exclude," without-exclude "without")
    (println "  ✓ Updated" (count updated-properties) "properties")))

(defn main [args]
  (let [action-str (first args)
        action (case action-str
                 "add" :add
                 "remove" :remove
                 nil)
        property-files ["source/action/properties.edn"
                        "source/common/properties.edn"
                        "source/creative-work/properties.edn"
                        "source/event/properties.edn"
                        "source/intangible/properties.edn"
                        "source/misc/properties.edn"
                        "source/organization/properties.edn"
                        "source/person/properties.edn"
                        "source/place/properties.edn"
                        "source/product/properties.edn"]]

    (when (nil? action)
      (println "Usage: bb scripts/toggle-exclude-from-graph.clj [add|remove]")
      (println "")
      (println "  add    - Add :exclude-from-graph-view true to all properties")
      (println "  remove - Remove :exclude-from-graph-view from all properties")
      (System/exit 1))

    (println (str "\n=== " (if (= action :add) "Adding" "Removing")
                  " :exclude-from-graph-view ===\n"))

    (doseq [file property-files]
      (when (.exists (io/file file))
        (try
          (process-properties-file file action)
          (catch Exception e
            (println "  ✗ Error processing" file ":" (.getMessage e))))))

    (println "\n=== Complete! ===")
    (println "Don't forget to rebuild templates:")
    (println "  npm run build:full\n")))

(main *command-line-args*)
