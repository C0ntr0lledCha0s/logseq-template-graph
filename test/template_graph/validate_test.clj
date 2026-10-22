(ns template-graph.validate-test
  (:require [clojure.string :as str]
            [clojure.test :refer [deftest is]]
            [template-graph.validate :as validate]))

(def vocab
  {:classes #{"Thing" "Person" "Event" "Project" "Rating"}
   :properties #{"email" "url" "event" "name"}})

(defn- sdef
  "A schema.* definition with matching title and url."
  [nm extra]
  (merge {:block/title nm
          :build/properties {:schema.property/url (str "https://schema.org/" nm)}}
         extra))

(defn- lib
  []
  {:classes {:schema.class/Thing (sdef "Thing" {:build/class-properties [:schema.property/url]})
             :schema.class/Person (sdef "Person" {:build/class-properties [:schema.property/email]
                                                  :build/class-extends [:schema.class/Thing]})}
   :properties {:schema.property/url (sdef "url" {:build/property-classes [:schema.class/Thing]})
                :schema.property/email (sdef "email" {:build/property-classes [:schema.class/Person]})}})

(defn- mentions?
  [errs s]
  (some #(str/includes? % s) errs))

(deftest valid-library-has-no-errors
  (is (empty? (validate/errors (lib) [] vocab))))

(deftest schema-name-not-in-vocab-flagged
  (let [l (assoc-in (lib) [:properties :schema.property/emial] (sdef "emial" {}))]
    (is (mentions? (validate/errors l [] vocab) "emial"))))

(deftest custom-name-in-vocab-flagged
  (let [l (assoc-in (lib) [:properties :custom.property/email] {})]
    (is (mentions? (validate/errors l [] vocab) "custom.property/email"))))

(deftest custom-name-checked-per-kind
  (let [l (-> (lib)
              (assoc-in [:properties :custom.property/project] {})
              (assoc-in [:properties :custom.property/rating] {})
              (assoc-in [:classes :custom.class/Resource] {}))]
    (is (empty? (validate/errors l [] vocab)))
    (is (mentions? (validate/errors (assoc-in l [:classes :custom.class/Project] {}) [] vocab)
                   "custom.class/Project"))))

(deftest no-dangling-refs
  (is (mentions? (validate/errors (assoc-in (lib) [:classes :schema.class/Person :build/class-properties] [:schema.property/name]) [] vocab)
                 "schema.property/name"))
  (is (mentions? (validate/errors (assoc-in (lib) [:classes :schema.class/Person :build/class-extends] [:schema.class/Event]) [] vocab)
                 "schema.class/Event"))
  (is (mentions? (validate/errors (assoc-in (lib) [:properties :schema.property/url :build/property-classes] [:schema.class/Event]) [] vocab)
                 "schema.class/Event"))
  (is (mentions? (validate/errors (assoc-in (lib) [:classes :schema.class/Person :build/properties] {:schema.property/name "x"}) [] vocab)
                 "schema.property/name")))

(deftest logseq-property-keys-allowed
  (is (empty? (validate/errors (assoc-in (lib) [:classes :schema.class/Person :build/properties] {:logseq.property/icon {}
                                                                                                  :schema.property/url "https://schema.org/Person"}) [] vocab))))

(deftest user-ident-flagged
  (is (mentions? (validate/errors (assoc-in (lib) [:classes :schema.class/Person :build/class-extends] [:user.class/Thing-abc]) [] vocab)
                 "user.class/Thing-abc")))

(deftest preset-unknown-class-flagged
  (is (mentions? (validate/errors (lib) [{:id "p" :classes {:schema.class/Event []}}] vocab)
                 "schema.class/Event")))

(deftest preset-inherited-property-rejected
  (is (mentions? (validate/errors (lib) [{:id "p" :classes {:schema.class/Person [:schema.property/url]}}] vocab)
                 "schema.property/url"))
  (is (empty? (validate/errors (lib) [{:id "p" :classes {:schema.class/Person [:schema.property/email]}}] vocab))))

(deftest case-collision-same-kind-fails
  (let [l (-> (lib)
              (assoc-in [:properties :schema.property/Email] (sdef "Email" {})))
        v (update vocab :properties conj "Email")]
    (is (mentions? (validate/errors l [] v) "case collision")))
  (let [l (-> (lib)
              (assoc-in [:classes :schema.class/Event] (sdef "Event" {}))
              (assoc-in [:properties :schema.property/event] (sdef "event" {})))]
    (is (empty? (validate/errors l [] vocab)))))

(deftest inconsistent-property-order-flagged
  (let [l (-> (lib)
              (assoc-in [:classes :schema.class/Thing :build/class-properties]
                        [:schema.property/url :schema.property/email])
              (assoc-in [:classes :schema.class/Person :build/class-properties]
                        [:schema.property/email :schema.property/url]))]
    (is (mentions? (validate/errors l [] vocab) "inconsistent property order"))))

(deftest unknown-namespace-keys-report-instead-of-throwing
  (let [bad-class (assoc-in (lib) [:classes :schema.clas/Foo] {})
        bad-prop (assoc-in (lib) [:properties :block/collapsed?] true)]
    (is (mentions? (validate/errors bad-class [] vocab) ":schema.clas/Foo"))
    (is (mentions? (validate/errors bad-prop [] vocab) ":block/collapsed?"))))

(deftest schema-entry-url-must-match-name
  (let [l (assoc-in (lib) [:properties :schema.property/url :build/properties :schema.property/url]
                    "https://schema.org/serviceArea")
        missing (update-in (lib) [:classes :schema.class/Thing :build/properties] dissoc :schema.property/url)]
    (is (mentions? (validate/errors l [] vocab) "schema.property/url must have"))
    (is (mentions? (validate/errors missing [] vocab) "schema.class/Thing must have"))))

(deftest schema-entry-title-must-match-name
  (let [l (assoc-in (lib) [:properties :schema.property/email :block/title] "Email")]
    (is (mentions? (validate/errors l [] vocab) ":block/title"))
    (is (mentions? (validate/errors (update-in (lib) [:classes :schema.class/Person] dissoc :block/title)
                                    [] vocab)
                   "schema.class/Person must have :block/title"))))

(deftest custom-entry-must-not-have-schema-url
  (let [l (assoc-in (lib) [:properties :custom.property/mine]
                    {:build/properties {:schema.property/url "https://schema.org/mine"}})]
    (is (mentions? (validate/errors l [] vocab) "custom.property/mine is custom but has"))
    (is (empty? (validate/errors (assoc-in (lib) [:properties :custom.property/mine] {}) [] vocab)))))

(deftest duplicate-preset-ids-flagged
  (is (mentions? (validate/errors (lib) [{:id "a" :classes {}} {:id "a" :classes {}}] vocab)
                 "duplicate preset id")))

(deftest non-keyword-refs-flagged
  (is (mentions? (validate/errors (assoc-in (lib) [:classes :schema.class/Thing :build/class-properties]
                                            ["url"])
                                  [] vocab)
                 "non-keyword entry"))
  (is (mentions? (validate/errors (assoc-in (lib) [:classes :schema.class/Person :build/class-extends]
                                            ["Thing"])
                                  [] vocab)
                 "non-keyword entry"))
  (is (mentions? (validate/errors (assoc-in (lib) [:properties :schema.property/url :build/property-classes]
                                            [1])
                                  [] vocab)
                 "non-keyword entry")))
