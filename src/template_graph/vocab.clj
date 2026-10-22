(ns template-graph.vocab
  (:require [cheshire.core :as json]
            [clojure.string :as str]))

(defn- types
  [entry]
  (let [t (get entry "@type")]
    (if (string? t) [t] t)))

(defn load-vocab
  "Read a Schema.org JSON-LD file into {:classes #{...} :properties #{...}}."
  [path]
  (let [graph (get (json/parse-string (slurp path)) "@graph")
        names-of (fn [type-name]
                   (->> graph
                        (filter #(some #{type-name} (types %)))
                        (map #(str/replace-first (get % "@id") "schema:" ""))
                        set))]
    {:classes (names-of "rdfs:Class")
     :properties (names-of "rdf:Property")}))
