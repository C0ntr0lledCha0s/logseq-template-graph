(ns template-graph.edn-io
  (:require [clojure.edn :as edn]
            [clojure.java.io :as io]
            [clojure.pprint :as pprint]))

(defn read-edn
  [path]
  (edn/read-string (slurp path)))

(defn edn-string
  [data]
  (binding [*print-namespace-maps* false]
    (with-out-str (pprint/pprint data))))

(defn write-edn!
  [path data]
  (spit path (edn-string data)))

(defn module-files
  "Sorted classes.edn / properties.edn paths under source/, excluding source/presets."
  []
  (->> (.listFiles (io/file "source"))
       (filter #(.isDirectory ^java.io.File %))
       (remove #(= "presets" (.getName ^java.io.File %)))
       (mapcat (fn [dir]
                 (for [f ["classes.edn" "properties.edn"]
                       :let [file (io/file dir f)]
                       :when (.exists file)]
                   (str "source/" (.getName ^java.io.File dir) "/" f))))
       sort
       vec))
