#!/usr/bin/env bb
;; Converts source/ module files in place from :user.* idents to :schema.* / :custom.* idents.
(require '[template-graph.convert :as convert]
         '[template-graph.edn-io :as io]
         '[template-graph.vocab :as vocab])

(let [files (io/module-files)
      modules (mapv io/read-edn files)
      vocab (vocab/load-vocab "vendor/schemaorg-current-https.json")
      m (convert/ident-map modules vocab)
      titles (into {} (for [module modules
                            section [:classes :properties]
                            [k v] (get module section)]
                        [k (:block/title v)]))
      files-of (into {} (for [[f module] (map vector files modules)
                              section [:classes :properties]
                              k (keys (get module section))]
                          [k f]))
      by-scope (group-by (fn [[_ v]] (if (= ::convert/drop v) :dropped (keyword (re-find #"^[a-z]+" (namespace v))))) m)
      renamed (filter (fn [[k v]] (and (not= ::convert/drop v) (not= (convert/base-name k) (name v)))) m)]
  (doseq [[f module] (map vector files modules)]
    (io/write-edn! f (convert/convert-module module m)))
  (println "schema :" (count (:schema by-scope)))
  (println "custom :" (count (:custom by-scope)))
  (println "dropped:" (count (:dropped by-scope)))
  (println "renamed:" (count renamed))
  (println "custom entries:")
  (doseq [[k v] (sort-by (comp str key) (:custom by-scope))]
    (println " " k "->" v "|" (titles k) "|" (files-of k)))
  (println "dropped entries:")
  (doseq [[k _] (sort-by (comp str key) (:dropped by-scope))]
    (println " " k "|" (titles k) "|" (files-of k)))
  (println "renamed entries:")
  (doseq [[k v] (sort-by (comp str key) renamed)]
    (println " " k "->" v)))
