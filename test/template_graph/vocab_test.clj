(ns template-graph.vocab-test
  (:require [clojure.test :refer [deftest is]]
            [template-graph.vocab :as vocab]))

(deftest loads-classes-and-properties
  (let [{:keys [classes properties]} (vocab/load-vocab "vendor/schemaorg-current-https.json")]
    (is (contains? classes "Person"))
    (is (contains? classes "LifestyleModification"))
    (is (contains? properties "email"))
    (is (contains? properties "parent"))
    (is (not (contains? classes "email")))
    (is (not (contains? properties "Person")))
    (is (not-any? #(.startsWith ^String % "schema:") (concat classes properties)))))
