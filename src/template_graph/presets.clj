(ns template-graph.presets
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [template-graph.edn-io :as edn-io]))

(defn presets-edn-string
  [presets version]
  (edn-io/edn-string {:schema-library/version version
                      :presets (vec presets)}))

(defn read-presets
  "Read source/presets/*.edn, sorted by id."
  []
  (->> (.listFiles (io/file "source/presets"))
       (filter #(.endsWith (.getName ^java.io.File %) ".edn"))
       (map edn-io/read-edn)
       (sort-by :id)
       vec))
