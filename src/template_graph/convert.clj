(ns template-graph.convert
  (:require [clojure.string :as str]
            [clojure.walk :as walk]))

(def overrides
  "Literal exceptions to the Schema.org rule, keyed by [kind base-name]."
  {[:class "LivestyleModification"] [:schema "LifestyleModification"]
   [:property "Parents"] [:schema "parent"]
   [:property "Rating"] [:custom "rating"]
   [:property "areas"] [:custom "areas"]
   [:property "project"] [:custom "project"]
   [:property "readBy"] [:custom "readBy"]
   [:class "Resource"] [:custom "Resource"]
   [:property "NewTest"] ::drop
   [:property "Event"] ::drop
   [:property "sourceSchema"] ::drop})

(def ^:private kinds {"user.class" :class "user.property" :property})

(defn base-name
  "Ident name before the first `-`."
  [kw]
  (first (str/split (name kw) #"-" 2)))

(defn- user-ident? [x]
  (and (keyword? x) (contains? kinds (namespace x))))

(defn- target
  [kind nm vocab]
  (let [override (get overrides [kind nm])]
    (if (= ::drop override)
      ::drop
      (let [[scope new-name] (or override
                                 (if (contains? (get vocab (if (= kind :class) :classes :properties)) nm)
                                   [:schema nm]
                                   [:custom nm]))]
        (keyword (str (clojure.core/name scope) "." (clojure.core/name kind)) new-name)))))

(defn- rewrite-idents
  [form m]
  (walk/postwalk
   (fn [x]
     (if (user-ident? x)
       (or (get m x) (throw (ex-info "unmapped user ident" {:ident x})))
       x))
   form))

(defn- entries
  [module]
  (for [[section kind] [[:classes :class] [:properties :property]]
        [k v] (get module section)]
    [kind k v]))

(defn ident-map
  [modules vocab]
  (let [all (mapcat entries modules)
        m (into {} (for [[kind k _] all]
                     [k (target kind (base-name k) vocab)]))]
    (doseq [[new-ident group] (group-by val (remove #(= ::drop (val %)) m))
            :let [olds (map key group)]
            :when (> (count olds) 1)
            :let [by-old (into {} (for [[_ k v] all :when (some #{k} olds)] [k (rewrite-idents v m)]))]
            :when (apply not= (vals by-old))]
      (throw (ex-info (str "duplicate target " new-ident " for " (pr-str (vec olds)))
                      {:target new-ident :old-idents (vec olds)})))
    m))

(defn- strip-dropped
  [form]
  (walk/postwalk
   (fn [x]
     (cond
       (instance? clojure.lang.MapEntry x) x
       (map? x) (into (empty x) (remove #(= ::drop (key %)) x))
       (vector? x) (into (empty x) (remove #{::drop}) x)
       (set? x) (into (empty x) (remove #{::drop}) x)
       (seq? x) (remove #{::drop} x)
       :else x))
   form))

(defn- finish-entry
  [old new-ident entry]
  (let [renamed? (not= (base-name old) (name new-ident))
        entry (cond-> entry renamed? (assoc :block/title (name new-ident)))
        entry (cond-> entry
                (= {} (:build/properties entry)) (dissoc :build/properties))]
    (if (.startsWith ^String (namespace new-ident) "schema.")
      (update-in entry [:build/properties :schema.property/url]
                 #(or % (str "https://schema.org/" (name new-ident))))
      entry)))

(defn convert-module
  [module m]
  (let [convert-section
        (fn [section]
          (into {}
                (for [[old entry] section
                      :let [new-ident (get m old)]
                      :when (not= ::drop new-ident)]
                  [new-ident (finish-entry old new-ident (strip-dropped (rewrite-idents entry m)))])))]
    (cond-> module
      (:classes module) (update :classes convert-section)
      (:properties module) (update :properties convert-section))))
