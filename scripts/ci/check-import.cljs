(ns check-import
  "Import the schema library into a fresh Logseq DB graph, then re-import it,
  using Logseq's own import code. Prints PASS on stdout; exits 1 on any error."
  (:require ["fs" :as fs]
            ["os" :as os]
            ["path" :as node-path]
            [clojure.edn :as edn]
            [datascript.core :as d]
            [logseq.db.sqlite.export :as sqlite-export]
            [logseq.outliner.cli :as outliner-cli]
            [nbb.classpath :as cp]))

(defn- fail! [label error]
  (println "FAIL" label (pr-str error))
  (js/process.exit 1))

(defn- import! [conn export-map label]
  (let [txs (try (sqlite-export/build-import export-map @conn {})
                 (catch :default e (fail! label (ex-message e))))]
    (when (:error txs)
      (fail! label (:error txs)))
    (let [{:keys [error tx-data]} (sqlite-export/validate-import-txs txs @conn)]
      (when error
        (fail! label error))
      (d/transact! conn tx-data {::sqlite-export/imported-data? true}))))

(defn -main [[edn-file]]
  (when-not edn-file
    (fail! "usage" "check-import.cljs <edn-file>"))
  (let [dir (fs/mkdtempSync (node-path/join (os/tmpdir) "schema-library-check-"))
        conn (outliner-cli/init-conn dir "check" {:classpath (cp/get-classpath)})
        m (edn/read-string {:readers {'uuid uuid}} (str (fs/readFileSync edn-file)))]
    (import! conn m "pass 1 (fresh import)")
    (import! conn m "pass 2 (re-import)")
    (println "PASS" (count (:classes m)) "classes" (count (:properties m)) "properties")))

(-main *command-line-args*)
