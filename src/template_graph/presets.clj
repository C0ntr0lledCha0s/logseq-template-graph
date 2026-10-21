(ns template-graph.presets
  (:require [clojure.java.io :as io]
            [clojure.string :as str]
            [template-graph.edn-io :as edn-io]))

(defn- preset-name
  [old-name]
  (str/replace old-name #" Template$" ""))

(defn expand-old-preset
  "Convert an old module-level preset into a class-level preset.
  module-maps is {module-name {:classes {...} :properties {...}}}."
  [id old-preset module-maps]
  (let [modules (or (:include old-preset) (keys module-maps))
        classes (into (sorted-map)
                      (for [module modules
                            [ident definition] (:classes (get module-maps module))]
                        [ident (vec (:build/class-properties definition))]))]
    {:id id
     :name (preset-name (:name old-preset))
     :description (or (:description old-preset) "")
     :classes classes}))

(defn presets-edn-string
  [presets version]
  (edn-io/edn-string {:schema-library/version version
                      :presets (vec presets)}))

(defn- base-name
  [^java.io.File f]
  (str/replace (.getName f) #"\.edn$" ""))

(defn source-module-maps
  "Read every source/<module> directory into {module-name {:classes :properties}}."
  []
  (into {}
        (for [dir (.listFiles (io/file "source"))
              :when (and (.isDirectory dir) (not= "presets" (.getName dir)))
              :let [read (fn [f] (let [file (io/file dir f)]
                                   (when (.exists file) (edn-io/read-edn file))))]]
          [(.getName dir) {:classes (:classes (read "classes.edn"))
                           :properties (:properties (read "properties.edn"))}])))

(defn convert-preset-files!
  "Rewrite source/presets/*.edn from the old format to the class-level format."
  []
  (let [module-maps (source-module-maps)]
    (doseq [^java.io.File f (sort-by #(.getName ^java.io.File %) (.listFiles (io/file "source/presets")))
            :when (.endsWith (.getName f) ".edn")]
      (edn-io/write-edn! f (expand-old-preset (base-name f) (edn-io/read-edn f) module-maps)))))

(defn read-presets
  "Read converted source/presets/*.edn, sorted by id."
  []
  (->> (.listFiles (io/file "source/presets"))
       (filter #(.endsWith (.getName ^java.io.File %) ".edn"))
       (map edn-io/read-edn)
       (sort-by :id)
       vec))
