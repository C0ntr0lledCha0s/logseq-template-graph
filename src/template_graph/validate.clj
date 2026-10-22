(ns template-graph.validate
  (:require [clojure.string :as str]
            [clojure.walk :as walk]))

(defn- kind-of
  [ident]
  (case (namespace ident)
    "schema.class" :class "custom.class" :class
    "schema.property" :property "custom.property" :property
    nil))

(defn- user-idents
  [data]
  (let [found (atom #{})]
    (walk/postwalk (fn [x]
                     (when (and (keyword? x) (some-> (namespace x) (str/starts-with? "user.")))
                       (swap! found conj x))
                     x)
                   data)
    @found))

(defn- known-ident?
  [lib ident]
  (case (kind-of ident)
    :class (contains? (:classes lib) ident)
    :property (contains? (:properties lib) ident)
    false))

(defn- ref-errors
  [lib where refs]
  (for [ref refs
        :when (or (not (keyword? ref))
                  (and (not= "logseq.property" (namespace ref))
                       (not (known-ident? lib ref))))]
    (if (keyword? ref)
      (str where " references unknown ident " ref)
      (str where " has non-keyword entry " (pr-str ref)))))

(defn- vocab-errors
  [vocab idents]
  (for [ident idents
        :let [kind (kind-of ident)]
        :when kind
        :let [nm (name ident)
              terms (get vocab (case kind :class :classes :property :properties))
              scope (namespace ident)
              exact? (contains? terms nm)
              any-case? (some #(.equalsIgnoreCase ^String % nm) terms)]
        :when (if (str/starts-with? scope "schema.") (not exact?) any-case?)]
    (if (str/starts-with? scope "schema.")
      (str ident " is not a Schema.org " (clojure.core/name kind))
      (str ident " is custom but Schema.org has a " (clojure.core/name kind) " named " nm))))

(defn- collision-errors
  [idents]
  (for [[[kind _lower] group] (group-by (fn [i] [(kind-of i) (str/lower-case (name i))]) idents)
        :when (and kind (> (count group) 1))]
    (str "case collision among " (name kind) " idents: " (str/join ", " (sort group)))))

(defn- invariant-errors
  "schema.* entries need url + title matching the ident name; custom.* entries must have no url."
  [lib]
  (for [section [:classes :properties]
        [ident d] (get lib section)
        :let [scope (namespace ident)
              url (get-in d [:build/properties :schema.property/url])]
        :when (some? scope)
        e (cond
            (str/starts-with? scope "schema.")
            (cond-> []
              (not= url (str "https://schema.org/" (name ident)))
              (conj (str ident " must have :schema.property/url https://schema.org/" (name ident)
                         " but has " (pr-str url)))
              (not= (get d :block/title) (name ident))
              (conj (str ident " must have :block/title " (pr-str (name ident))
                         " but has " (pr-str (get d :block/title)))))
            (str/starts-with? scope "custom.")
            (when (some? url)
              [(str ident " is custom but has :schema.property/url " (pr-str url))])
            :else nil)]
    e))

(defn- property-order-errors
  "Flag property pairs ordered x-before-y in one class and y-before-x in another."
  [lib]
  (let [pairs (fn [props] (for [[i x] (map-indexed vector props)
                                y (drop (inc i) props)]
                            [x y]))
        seen (reduce (fn [m [class d]]
                       (reduce (fn [m pair] (update m pair (fnil conj #{}) class))
                               m (pairs (:build/class-properties d))))
                     {} (:classes lib))]
    (for [[[x y] classes] seen
          :when (and (neg? (compare (str x) (str y))) (contains? seen [y x]))]
      (str "inconsistent property order: " x " and " y " are ordered differently in "
           (str/join ", " (sort (into classes (get seen [y x]))))))))

(defn- library-errors
  [lib vocab]
  (concat
   (for [i (user-idents lib)] (str "user ident not allowed: " i))
   (for [section [:classes :properties]
         ident (keys (get lib section))
         :when (not= section (case (kind-of ident) :class :classes :property :properties nil))]
     (str ident " is in " section " with a mismatched namespace"))
   (for [[ident d] (:classes lib)
         e (concat (ref-errors lib (str ident " class-properties") (:build/class-properties d))
                   (ref-errors lib (str ident " class-extends") (:build/class-extends d))
                   (ref-errors lib (str ident " build/properties") (keys (:build/properties d))))]
     e)
   (for [[ident d] (:properties lib)
         e (concat (ref-errors lib (str ident " property-classes") (:build/property-classes d))
                   (ref-errors lib (str ident " build/properties") (keys (:build/properties d))))]
     e)
   (property-order-errors lib)
   (invariant-errors lib)
   (vocab-errors vocab (concat (keys (:classes lib)) (keys (:properties lib))))
   (collision-errors (concat (keys (:classes lib)) (keys (:properties lib))))))

(defn- preset-errors
  [lib preset]
  (for [[class props] (:classes preset)
        e (if-let [definition (get (:classes lib) class)]
            (let [direct (set (:build/class-properties definition))]
              (for [p props :when (not (contains? direct p))]
                (str "preset " (:id preset) ": " p " is not a direct property of " class)))
            [(str "preset " (:id preset) ": unknown class " class)])]
    e))

(defn errors
  "Validate library and presets against the Schema.org vocab. Empty means valid."
  [lib presets vocab]
  (vec (concat (library-errors lib vocab)
               (for [[id n] (frequencies (map :id presets))
                     :when (> n 1)]
                 (str "duplicate preset id " (pr-str id)))
               (mapcat #(preset-errors lib %) presets))))
