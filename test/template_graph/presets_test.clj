(ns template-graph.presets-test
  (:require [clojure.test :refer [deftest is]]
            [template-graph.presets :as presets]))

(deftest presets-edn-string-carries-version
  (let [s (presets/presets-edn-string [{:id "crm"}] "1.2.0")]
    (is (= {:schema-library/version "1.2.0" :presets [{:id "crm"}]} (read-string s)))))
