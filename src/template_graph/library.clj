(ns template-graph.library
  (:require [template-graph.edn-io :as edn-io]))

(defn- merge-section
  [section acc module]
  (reduce-kv
   (fn [m ident definition]
     (when (and (contains? m ident) (not= (get m ident) definition))
       (throw (ex-info "conflicting definitions"
                       {:section section :ident ident})))
     (assoc m ident definition))
   acc
   (get module section)))

(defn merge-modules
  [modules]
  (reduce (fn [acc module]
            {:classes (merge-section :classes (:classes acc) module)
             :properties (merge-section :properties (:properties acc) module)})
          {:classes {} :properties {}}
          modules))

(defn library-map
  [merged version]
  (assoc merged
         :logseq.db.sqlite.export/export-type :graph-ontology
         :schema-library/version version))

(defn library-edn-string
  [lib]
  (edn-io/edn-string lib))
