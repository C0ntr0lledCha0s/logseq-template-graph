(ns template-graph.edn-io-test
  (:require [clojure.test :refer [deftest is]]
            [template-graph.edn-io :as edn-io])
  (:import (java.io File)))

(defn- tmp
  [content]
  (let [f (File/createTempFile "edn-io-test" ".edn")]
    (.deleteOnExit f)
    (spit f content)
    (str f)))

(defn- fails-naming-path?
  [content]
  (let [path (tmp content)]
    (try (edn-io/read-edn path) false
         (catch clojure.lang.ExceptionInfo e (.contains (ex-message e) path)))))

(deftest reads-valid-map
  (is (= {:a 1 :b {:c 2}} (edn-io/read-edn (tmp "{:a 1 :b {:c 2}}\n")))))

(deftest rejects-trailing-form
  (is (fails-naming-path? "{:a 1} {:b 2}")))

(deftest rejects-stray-closing-brace
  (is (fails-naming-path? "{:a {:b 1}} }\n{:c 2}"))
  (is (fails-naming-path? "{:a {:b 1}}}")))

(deftest rejects-empty-file
  (is (fails-naming-path? ""))
  (is (fails-naming-path? "  ; just a comment\n")))

(deftest rejects-non-map
  (is (fails-naming-path? "[1 2 3]"))
  (is (fails-naming-path? ":kw")))

(deftest rejects-parse-error
  (is (fails-naming-path? "{:a ")))
