(ns template-graph.run-tests
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [clojure.test :as t]))

(defn- test-namespaces
  []
  (->> (.listFiles (io/file "test/template_graph"))
       (map (fn [f] (.getName ^java.io.File f)))
       (filter (fn [n] (str/ends-with? n "_test.clj")))
       sort
       (map (fn [n] (symbol (str "template-graph." (-> n (str/replace ".clj" "") (str/replace "_" "-"))))))))

(defn -main
  []
  (let [nss (test-namespaces)]
    (apply require nss)
    (let [{:keys [fail error]} (apply t/run-tests nss)]
      (System/exit (if (zero? (+ fail error)) 0 1)))))
