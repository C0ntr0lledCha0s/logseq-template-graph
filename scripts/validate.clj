#!/usr/bin/env bb
;; Validates build/schema-library.edn and build/schema-presets.edn against Schema.org.
(require '[template-graph.edn-io :as edn-io]
         '[template-graph.validate :as validate]
         '[template-graph.vocab :as vocab])

(let [lib (edn-io/read-edn "build/schema-library.edn")
      presets (:presets (edn-io/read-edn "build/schema-presets.edn"))
      errs (validate/errors lib presets (vocab/load-vocab "vendor/schemaorg-current-https.json"))]
  (if (seq errs)
    (do (doseq [e errs] (println e))
        (println (count errs) "errors")
        (System/exit 1))
    (println "Valid")))
