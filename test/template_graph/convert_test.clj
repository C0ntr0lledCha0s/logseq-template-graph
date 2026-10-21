(ns template-graph.convert-test
  (:require [clojure.test :refer [deftest is testing]]
            [template-graph.convert :as convert]))

(def vocab
  {:classes #{"Thing" "Person" "Event" "LifestyleModification" "WebSite" "ChildrensEvent"}
   :properties #{"email" "event" "parent" "url" "backstory" "requiredMinAge"}})

(defn- idents
  [& kws]
  (convert/ident-map [{:classes (into {} (for [k kws :when (= "user.class" (namespace k))] [k {}]))
                       :properties (into {} (for [k kws :when (= "user.property" (namespace k))] [k {}]))}]
                     vocab))

(deftest base-name-strips-suffix
  (is (= "sameAs" (convert/base-name :user.property/sameAs-d-nt_wFF)))
  (is (= "superEvent" (convert/base-name :user.property/superEvent-AdQv8SI-))))

(deftest maps-schema-terms
  (let [m (idents :user.class/Person-cB8UklzM :user.property/email-UL_S9FXV)]
    (is (= :schema.class/Person (m :user.class/Person-cB8UklzM)))
    (is (= :schema.property/email (m :user.property/email-UL_S9FXV)))))

(deftest applies-renames
  (let [m (idents :user.class/LivestyleModification-X :user.property/Parents-X
                  :user.property/Event-X :user.property/event-Y :user.property/Rating-X)]
    (is (= :schema.class/LifestyleModification (m :user.class/LivestyleModification-X)))
    (is (= :schema.property/parent (m :user.property/Parents-X)))
    (is (= ::convert/drop (m :user.property/Event-X)))
    (is (= :schema.property/event (m :user.property/event-Y)))
    (is (= :custom.property/rating (m :user.property/Rating-X)))))

(deftest non-schema-goes-custom
  (let [m (idents :user.property/areas-X :user.class/Resource-X)]
    (is (= :custom.property/areas (m :user.property/areas-X)))
    (is (= :custom.class/Resource (m :user.class/Resource-X)))))

(deftest drops-newtest-and-sourceschema
  (let [m (idents :user.property/NewTest-X :user.property/sourceSchema-mW7IZAwI)]
    (is (= ::convert/drop (m :user.property/NewTest-X)))
    (is (= ::convert/drop (m :user.property/sourceSchema-mW7IZAwI)))))

(deftest rewrites-build-properties-keys
  (let [module {:classes {:user.class/Person-cB8UklzM
                          {:block/title "Person"
                           :build/class-properties [:user.property/sourceSchema-mW7IZAwI
                                                    :user.property/email-UL_S9FXV]
                           :build/properties
                           {:user.property/sourceSchema-mW7IZAwI [:block/uuid #uuid "67cfe8f6-6242-4a22-b196-8f6b95e96d8a"]
                            :logseq.property/description "d"}}}}
        m (idents :user.class/Person-cB8UklzM :user.property/sourceSchema-mW7IZAwI :user.property/email-UL_S9FXV)
        entry (get-in (convert/convert-module module m) [:classes :schema.class/Person])]
    (is (= {:logseq.property/description "d"
            :schema.property/url "https://schema.org/Person"}
           (:build/properties entry)))
    (is (= [:schema.property/email] (:build/class-properties entry)))))

(deftest drops-entries-and-adds-url-to-properties
  (let [module {:properties {:user.property/NewTest-X {:block/title "NewTest"}
                             :user.property/areas-X {:block/title "areas"}
                             :user.property/email-UL_S9FXV {:block/title "email"}}}
        m (idents :user.property/NewTest-X :user.property/areas-X :user.property/email-UL_S9FXV)
        props (:properties (convert/convert-module module m))]
    (is (= #{:custom.property/areas :schema.property/email} (set (keys props))))
    (is (= "https://schema.org/email" (get-in props [:schema.property/email :build/properties :schema.property/url])))
    (is (nil? (get-in props [:custom.property/areas :build/properties])))))

(deftest renamed-title-updated
  (let [module {:properties {:user.property/Parents-X {:block/title "parents"}
                             :user.property/email-Y {:block/title "E-mail"}}}
        m (idents :user.property/Parents-X :user.property/email-Y)
        props (:properties (convert/convert-module module m))]
    (is (= "parent" (get-in props [:schema.property/parent :block/title])))
    (is (= "E-mail" (get-in props [:schema.property/email :block/title])))))

(deftest duplicate-targets-are-reported
  (let [mods (fn [a b]
               [{:properties {:user.property/email-A a :user.property/email-B b}}])]
    (testing "different entries throw"
      (let [e (is (thrown-with-msg? clojure.lang.ExceptionInfo #"duplicate target"
                                    (convert/ident-map (mods {:block/title "a"} {:block/title "b"}) vocab)))]
        (is (= #{:user.property/email-A :user.property/email-B}
               (set (:old-idents (ex-data e)))))))
    (testing "equal entries merge"
      (let [m (convert/ident-map (mods {:block/title "a"} {:block/title "a"}) vocab)]
        (is (= :schema.property/email (m :user.property/email-A) (m :user.property/email-B)))))))

(deftest no-user-idents-remain
  (let [module {:classes {:user.class/Person-cB8UklzM
                          {:build/class-extends [:user.class/Thing-K1x5zUhw]
                           :build/class-properties [:user.property/email-UL_S9FXV]}}}
        m (idents :user.class/Person-cB8UklzM :user.class/Thing-K1x5zUhw :user.property/email-UL_S9FXV)
        result (convert/convert-module module m)]
    (is (nil? (re-find #":user\." (pr-str result))))))

(deftest unmapped-user-ident-fails-fast
  (is (thrown-with-msg? clojure.lang.ExceptionInfo #"unmapped"
                        (convert/convert-module {:classes {:user.class/Person-X {:build/class-extends [:user.class/Nope-Y]}}}
                                                (idents :user.class/Person-X)))))

(deftest empty-build-properties-removed
  (let [module {:properties {:user.property/NewTest-X {:block/title "NewTest"}
                             :user.property/Foo-X
                             {:block/title "Foo"
                              :build/properties {:user.property/NewTest-X "x"}}}}
        m (convert/ident-map [module] vocab)
        out (convert/convert-module module m)
        entry (get-in out [:properties :custom.property/Foo])]
    (is (some? entry))
    (is (not (contains? entry :build/properties)))))

(deftest case-variant-maps-to-schema-casing
  (let [m (idents :user.class/Website-X :user.property/backStory-Y)]
    (is (= :schema.class/WebSite (m :user.class/Website-X)))
    (is (= :schema.property/backstory (m :user.property/backStory-Y)))))

(deftest typo-renames
  (let [m (idents :user.class/ChildernsEvent-X :user.property/requiredAge-Y)]
    (is (= :schema.class/ChildrensEvent (m :user.class/ChildernsEvent-X)))
    (is (= :schema.property/requiredMinAge (m :user.property/requiredAge-Y)))))
