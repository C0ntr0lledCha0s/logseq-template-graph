(ns template-graph.edn-io
  (:require [clojure.edn :as edn]
            [clojure.java.io :as io]
            [clojure.pprint :as pprint]))

(defn read-edn
  "Read exactly one EDN map from path. Throws ex-info naming the path for parse
  errors, empty files, non-map top-level forms, and trailing content."
  [path]
  (let [fail (fn [what data] (throw (ex-info (str path ": " what) (assoc data :path (str path)))))
        eof (Object.)
        rdr (java.io.PushbackReader. (io/reader (io/file path)))
        read1 (fn [] (try (edn/read {:eof eof} rdr)
                          (catch Exception e
                            (throw (ex-info (str path ": EDN parse error: " (ex-message e))
                                            {:path (str path)} e)))))
        form (read1)]
    (when (identical? form eof) (fail "empty EDN file" {}))
    (when-not (map? form) (fail "top-level form must be a map" {:type (type form)}))
    (let [extra (read1)]
      (when-not (identical? extra eof)
        (fail "unexpected content after the top-level map" {:extra extra})))
    form))

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
