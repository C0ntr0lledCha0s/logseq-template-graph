#!/usr/bin/env bb
(require '[clojure.edn :as edn]
         '[clojure.java.io :as io]
         '[clojure.pprint :as pp])

(defn add-exclude-to-property
  "Add :exclude-from-graph-view true to a property definition"
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

(defn process-properties-file
  "Process a properties EDN file and add exclude-from-graph-view to all properties"
  [file-path]
  (println "Processing:" file-path)
  (let [content (slurp file-path)
        data (edn/read-string content)
        properties (:properties data)

        ;; Transform all properties
        updated-properties (into {}
                                 (map (fn [[k v]]
                                        [k (add-exclude-to-property v)])
                                      properties))

        ;; Create updated data structure
        updated-data (assoc data :properties updated-properties)]

    ;; Write back to file
    (with-open [w (io/writer file-path)]
      (binding [*out* w
                *print-namespace-maps* false]
        (pp/pprint updated-data)))

    (println "  ✓ Updated" (count updated-properties) "properties")))

(defn main []
  (let [property-files ["source/common/properties.edn"
                        "source/action/properties.edn"
                        "source/creative-work/properties.edn"
                        "source/event/properties.edn"
                        "source/intangible/properties.edn"
                        "source/misc/properties.edn"
                        "source/organization/properties.edn"
                        "source/person/properties.edn"
                        "source/place/properties.edn"
                        "source/product/properties.edn"]]

    (println "\n=== Adding :exclude-from-graph-view true to all properties ===\n")

    (doseq [file property-files]
      (when (.exists (io/file file))
        (try
          (process-properties-file file)
          (catch Exception e
            (println "  ✗ Error processing" file ":" (.getMessage e))))))

    (println "\n=== Complete! ===\n")))

(main)
