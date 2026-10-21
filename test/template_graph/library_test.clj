(ns template-graph.library-test
  (:require [clojure.edn :as edn]
            [clojure.test :refer [deftest is testing]]
            [template-graph.library :as library]))

(deftest merge-combines-modules
  (let [merged (library/merge-modules
                [{:classes {:schema.class/A {:title "A"}}
                  :properties {:schema.property/a {:title "a"}}}
                 {:classes {:schema.class/B {:title "B"}}}])]
    (is (= #{:schema.class/A :schema.class/B} (set (keys (:classes merged)))))
    (is (= #{:schema.property/a} (set (keys (:properties merged)))))))

(deftest merge-accepts-identical-duplicates
  (let [m {:classes {:schema.class/A {:title "A"}}}]
    (is (= m (select-keys (library/merge-modules [m m]) [:classes])))))

(deftest merge-rejects-conflicts
  (is (thrown-with-msg?
       clojure.lang.ExceptionInfo #"conflicting definitions"
       (library/merge-modules
        [{:classes {:schema.class/A {:title "A"}}}
         {:classes {:schema.class/A {:title "Other"}}}]))))

(deftest library-has-export-type-and-version
  (let [lib (library/library-map {:classes {} :properties {}} "9.9.9")]
    (is (= :graph-ontology (get lib :logseq.db.sqlite.export/export-type)))
    (is (= "9.9.9" (:schema-library/version lib)))))

(deftest edn-string-has-no-namespace-maps
  (let [lib (library/library-map
             {:classes {:schema.class/A {:title "A"}}
              :properties {:schema.property/a {:title "a"}}}
             "1.0.0")
        s (library/library-edn-string lib)]
    (testing "no #:ns{} literals"
      (is (nil? (re-find #"#:" s))))
    (is (= lib (edn/read-string s)))))

(deftest property-order-made-consistent
  (let [lib (library/normalize-property-order
             {:classes {:schema.class/A {:build/class-properties [:p/x :p/y]}
                        :schema.class/B {:build/class-extends [:schema.class/A]
                                         :build/class-properties [:p/y :p/x :p/z]}}})]
    (is (= [:p/x :p/y] (get-in lib [:classes :schema.class/A :build/class-properties])))
    (is (= [:p/x :p/y :p/z] (get-in lib [:classes :schema.class/B :build/class-properties])))))

(deftest property-order-keeps-first-class-order
  (let [lib (library/normalize-property-order
             {:classes {:schema.class/A {:build/class-properties [:p/z :p/a :p/m]}}})]
    (is (= [:p/z :p/a :p/m] (get-in lib [:classes :schema.class/A :build/class-properties])))))
