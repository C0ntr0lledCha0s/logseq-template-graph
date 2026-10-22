#!/usr/bin/env bb
;; Builds build/schema-library.edn and build/schema-presets.edn from all source/ module files.
(require '[cheshire.core :as json]
         '[clojure.java.io :as io]
         '[template-graph.edn-io :as edn-io]
         '[template-graph.library :as library]
         '[template-graph.presets :as presets])

(let [version (get (json/parse-string (slurp "package.json")) "version")
      files (edn-io/module-files)
      modules (mapv edn-io/read-edn files)
      lib (library/library-map (library/merge-modules modules files) version)]
  (io/make-parents "build/schema-library.edn")
  (spit "build/schema-library.edn" (library/library-edn-string lib))
  (println "classes   :" (count (:classes lib)))
  (println "properties:" (count (:properties lib)))
  (println "version   :" version)
  (println "wrote build/schema-library.edn")
  (spit "build/schema-presets.edn" (presets/presets-edn-string (presets/read-presets) version))
  (println "wrote build/schema-presets.edn"))
