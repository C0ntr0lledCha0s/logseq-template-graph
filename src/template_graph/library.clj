(ns template-graph.library
  (:require [template-graph.edn-io :as edn-io]))

(defn- merge-section
  [section acc module where]
  (reduce-kv
   (fn [m ident definition]
     (when (and (contains? m ident) (not= (get m ident) definition))
       (throw (ex-info (str "conflicting definitions for " ident " in " (name section)
                            (when where (str " (module " where ")")))
                       {:section section :ident ident :module where})))
     (assoc m ident definition))
   acc
   (get module section)))

(defn merge-modules
  "Merge modules. Optional paths (parallel to modules) name the module in conflict errors."
  ([modules] (merge-modules modules (repeat (count modules) nil)))
  ([modules paths]
   (reduce (fn [acc [module where]]
             {:classes (merge-section :classes (:classes acc) module where)
              :properties (merge-section :properties (:properties acc) module where)})
           {:classes {} :properties {}}
           (map vector modules paths))))

(defn- class-depth
  "Depth from the root via :build/class-extends (minimum over parents present in classes)."
  [classes ident]
  (letfn [(depth [i seen]
            (let [parents (->> (:build/class-extends (get classes i))
                               (filter #(and (contains? classes %) (not (contains? seen %)))))]
              (if (empty? parents)
                0
                (inc (apply min (map #(depth % (conj seen i)) parents))))))]
    (depth ident #{ident})))

(defn normalize-property-order
  "Sort every class's :build/class-properties by one global rank so class orders
  never conflict. Rank is first appearance walking classes by depth, then ident."
  [lib]
  (let [classes (:classes lib)
        walk-order (sort-by (juxt #(class-depth classes %) str) (keys classes))
        rank (reduce (fn [m p] (if (contains? m p) m (assoc m p (count m))))
                     {}
                     (mapcat #(:build/class-properties (get classes %)) walk-order))]
    (update lib :classes
            update-vals
            (fn [d]
              (cond-> d
                (:build/class-properties d)
                (update :build/class-properties #(vec (sort-by rank %))))))))

(defn library-map
  [merged version]
  (assoc (normalize-property-order merged)
         :logseq.db.sqlite.export/export-type :graph-ontology
         :schema-library/version version))

(defn library-edn-string
  [lib]
  (edn-io/edn-string lib))
