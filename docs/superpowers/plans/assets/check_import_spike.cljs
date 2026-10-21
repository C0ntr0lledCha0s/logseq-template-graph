(ns check-import
  "Spike: import an ontology EDN into a fresh graph, re-import, trim, and conflict-test."
  (:require ["fs" :as fs]
            ["os" :as os]
            ["path" :as node-path]
            [clojure.edn :as edn]
            [datascript.core :as d]
            [logseq.db.sqlite.export :as sqlite-export]
            [logseq.outliner.cli :as outliner-cli]
            [nbb.classpath :as cp]))

(defn- import! [conn export-map label]
  (let [txs (sqlite-export/build-import export-map @conn {})]
    (if (:error txs)
      (println label "BUILD ERROR:" (:error txs))
      (let [{:keys [error tx-data]} (sqlite-export/validate-import-txs txs @conn)]
        (if error
          (println label "VALIDATION ERROR:" error)
          (do (d/transact! conn tx-data {::sqlite-export/imported-data? true})
              (println label "OK" (count tx-data) "datoms")))))))

(defn- class-prop-count [conn ident]
  (count (:logseq.property.class/properties (d/entity @conn ident))))

(defn -main [[edn-file]]
  (let [dir (fs/mkdtempSync (node-path/join (os/tmpdir) "ontology-check-"))
        conn (outliner-cli/init-conn dir "check" {:classpath (cp/get-classpath)})
        m (edn/read-string {:readers {'uuid uuid}} (str (fs/readFileSync edn-file)))]
    (import! conn m "1. fresh import:")
    (println "   Person class properties:" (class-prop-count conn :schema.class/Person))
    (import! conn m "2. identical re-import:")
    (println "   Person class properties:" (class-prop-count conn :schema.class/Person))
    (let [trimmed (update-in m [:classes :schema.class/Person :build/class-properties] #(vec (take 2 %)))]
      (import! conn trimmed "3. re-import with Person trimmed to 2:")
      (println "   Person class properties:" (class-prop-count conn :schema.class/Person)))
    (let [k (first (keep (fn [[k v]] (when (= :default (:logseq.property/type v)) k)) (:properties m)))
          clash (assoc-in m [:properties k :logseq.property/type] :number)]
      (import! conn clash (str "4. re-import with " k " changed to :number:")))))

(-main *command-line-args*)
