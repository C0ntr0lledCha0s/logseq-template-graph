#!/usr/bin/env bb
;; Builds build/schema-library.edn from all source/ module files.
(require '[cheshire.core :as json]
         '[clojure.java.io :as io]
         '[template-graph.edn-io :as edn-io]
         '[template-graph.library :as library])

(let [version (get (json/parse-string (slurp "package.json")) "version")
      modules (mapv edn-io/read-edn (edn-io/module-files))
      lib (library/library-map (library/merge-modules modules) version)]
  (io/make-parents "build/schema-library.edn")
  (spit "build/schema-library.edn" (library/library-edn-string lib))
  (println "classes   :" (count (:classes lib)))
  (println "properties:" (count (:properties lib)))
  (println "version   :" version)
  (println "wrote build/schema-library.edn"))
