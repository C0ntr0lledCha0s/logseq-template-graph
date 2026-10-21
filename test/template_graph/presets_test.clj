(ns template-graph.presets-test
  (:require [clojure.test :refer [deftest is]]
            [template-graph.presets :as presets]))

(def module-maps
  {"person" {:classes {:schema.class/Person {:build/class-properties [:schema.property/email :schema.property/name]}
                       :schema.class/Patient {:build/class-extends [:schema.class/Person]}}}
   "place" {:classes {:schema.class/Place {:build/class-properties [:schema.property/address]}}}})

(deftest expand-crm-preset
  (let [p (presets/expand-old-preset "crm" {:name "CRM Template" :description "d" :include ["person"]} module-maps)]
    (is (= "crm" (:id p)))
    (is (= "CRM" (:name p)))
    (is (= "d" (:description p)))
    (is (= {:schema.class/Person [:schema.property/email :schema.property/name]
            :schema.class/Patient []}
           (:classes p)))))

(deftest nil-include-means-all-modules
  (let [p (presets/expand-old-preset "full" {:name "Full Template" :include nil} module-maps)]
    (is (= "" (:description p)))
    (is (= 3 (count (:classes p))))))

(deftest presets-edn-string-carries-version
  (let [s (presets/presets-edn-string [{:id "crm"}] "1.2.0")]
    (is (= {:schema-library/version "1.2.0" :presets [{:id "crm"}]} (read-string s)))))
