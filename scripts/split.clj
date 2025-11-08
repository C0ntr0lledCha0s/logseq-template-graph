#!/usr/bin/env bb

;; Logseq Template Splitter
;; Splits monolithic EDN template into modular source files

(require '[clojure.edn :as edn]
         '[clojure.java.io :as io]
         '[clojure.string :as str]
         '[clojure.pprint :refer [pprint]])

(def COLORS
  {:green "\033[0;32m"
   :yellow "\033[1;33m"
   :cyan "\033[0;36m"
   :red "\033[0;31m"
   :reset "\033[0m"})

(defn colorize [color text]
  (str (COLORS color) text (COLORS :reset)))

(defn read-edn-file [path]
  "Read and parse EDN file"
  (println (colorize :yellow (str "📖 Reading " path "...")))
  (-> path slurp edn/read-string))

(defn class-title->category [class-title]
  "Map class name to source category based on Schema.org hierarchy"
  (let [title (str/lower-case (or class-title ""))]
    (cond
      ;; Base
      (= title "thing") "base"
      (= title "resource") "base"

      ;; Person
      (str/includes? title "person") "person"

      ;; Organization
      (or (str/includes? title "organization")
          (str/includes? title "occupation")
          (str/includes? title "department")
          (str/includes? title "business")
          (str/includes? title "brand")
          (and (str/includes? title "group")
               (not (str/includes? title "family")))) "organization"

      ;; Event
      (or (str/includes? title "event")
          (str/includes? title "meeting")
          (str/includes? title "schedule")
          (str/includes? title "festival")
          (str/includes? title "courseinstance")) "event"

      ;; Place (expanded: geographic + infrastructure)
      (or (str/includes? title "place")
          (str/includes? title "location")
          (str/includes? title "city")
          (str/includes? title "country")
          (str/includes? title "state")
          (str/includes? title "administrative")
          (str/includes? title "airport")
          (str/includes? title "station")
          (str/includes? title "terminal")
          (str/includes? title "stop")
          (str/includes? title "civic")
          (str/includes? title "localbusiness")
          (str/includes? title "touristdestination")) "place"

      ;; CreativeWork (expanded: music, TV, documents, software, learning)
      (or (str/includes? title "creative")
          (str/includes? title "book")
          (str/includes? title "article")
          (str/includes? title "video")
          (str/includes? title "audio")
          (str/includes? title "image")
          (str/includes? title "media")
          (str/includes? title "work")
          ;; Music
          (str/includes? title "music")
          (str/includes? title "song")
          (str/includes? title "album")
          (str/includes? title "playlist")
          (str/includes? title "recording")
          (str/includes? title "composition")
          (str/includes? title "release")
          ;; TV/Film
          (str/includes? title "movie")
          (str/includes? title "film")
          (str/includes? title "tv")
          (str/includes? title "episode")
          (str/includes? title "series")
          (str/includes? title "season")
          ;; Documents
          (str/includes? title "document")
          (str/includes? title "spreadsheet")
          (str/includes? title "presentation")
          (str/includes? title "note")
          ;; Software
          (str/includes? title "software")
          (str/includes? title "application")
          (str/includes? title "sourcecode")
          (str/includes? title "website")
          ;; Learning
          (str/includes? title "course")
          (str/includes? title "syllabus")
          (str/includes? title "learningresource")
          ;; Other CreativeWork
          (str/includes? title "game")
          (str/includes? title "conversation")
          (str/includes? title "report")
          (str/includes? title "certification")
          (str/includes? title "guide")
          (str/includes? title "recommendation")
          (str/includes? title "review")) "creative-work"

      ;; Product
      (or (str/includes? title "product")
          (str/includes? title "offer")) "product"

      ;; Action
      (str/includes? title "action") "action"

      ;; Health (new category)
      (or (str/includes? title "physical")
          (str/includes? title "exercise")
          (str/includes? title "diet")
          (str/includes? title "lifestyle")
          (str/includes? title "livestyle")  ;; typo variant
          (str/includes? title "wellness")) "health"

      ;; Intangible (expanded: trips, reservations, services, structures)
      (or (str/includes? title "intangible")
          (str/includes? title "audience")
          (str/includes? title "rating")
          ;; Note: "review" moved to creative-work above
          ;; Trips & Travel
          (str/includes? title "trip")
          (str/includes? title "flight")
          (str/includes? title "tourist")
          ;; Reservations
          (str/includes? title "reservation")
          (str/includes? title "ticket")
          ;; Memberships
          (str/includes? title "membership")
          (str/includes? title "program")
          (str/includes? title "tier")
          ;; Services
          (str/includes? title "service")
          (str/includes? title "api")
          ;; Structured data
          (str/includes? title "value")
          (str/includes? title "duration")
          (str/includes? title "structured")
          (str/includes? title "quantitative")
          ;; Lists
          (str/includes? title "list")
          ;; Education-related intangibles
          (str/includes? title "alignment")
          ;; Languages
          (str/includes? title "computerlanguage")) "intangible"

      ;; Default
      :else "misc")))

(defn property-classes->category [prop-classes]
  "Determine category based on property's associated classes"
  (if (empty? prop-classes)
    "common"
    (let [class-ids (map name prop-classes)
          categories (map class-title->category class-ids)
          category-freq (frequencies categories)
          [most-common _] (first (sort-by val > category-freq))]
      (or most-common "common"))))

(defn split-properties [properties]
  "Split properties by category"
  (println (colorize :cyan "\n📦 Analyzing properties..."))
  (let [grouped (group-by
                  (fn [[prop-id prop-def]]
                    (property-classes->category
                      (get-in prop-def [:build/property-classes])))
                  properties)]
    (doseq [[category props] grouped]
      (println (str "  " category ": " (count props) " properties")))
    grouped))

(defn split-classes [classes]
  "Split classes by category"
  (println (colorize :cyan "\n📦 Analyzing classes..."))
  (let [grouped (group-by
                  (fn [[class-id class-def]]
                    (class-title->category (:block/title class-def)))
                  classes)]
    (doseq [[category clss] grouped]
      (println (str "  " category ": " (count clss) " classes")))
    grouped))

(defn write-module [category type data]
  "Write module file to source directory"
  (let [dir (str "source/" category)
        file (str dir "/" type ".edn")]
    (io/make-parents file)
    (spit file (with-out-str (pprint data)))
    (println (colorize :green (str "  ✅ " file)))))

(defn create-readme [category stats]
  "Create README for module category"
  (let [dir (str "source/" category)
        file (str dir "/README.md")
        content (str "# " (str/capitalize category) " Module\n\n"
                     "## Contents\n\n"
                     "- **Classes**: " (:classes stats 0) "\n"
                     "- **Properties**: " (:properties stats 0) "\n\n"
                     "## Files\n\n"
                     "- `classes.edn` - Class definitions\n"
                     "- `properties.edn` - Property definitions\n\n"
                     "## Schema.org Reference\n\n"
                     "See: https://schema.org/\n")]
    (io/make-parents file)
    (spit file content)))

(defn split-template [input-file]
  "Main split function"
  (println (colorize :cyan "🔪 Splitting Logseq Template into Modules"))
  (println (colorize :cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n"))

  (let [template (read-edn-file input-file)
        properties (:properties template)
        classes (:classes template)]

    (println (colorize :yellow (str "\n📊 Total: "
                                    (count properties) " properties, "
                                    (count classes) " classes\n")))

    ;; Split properties by category
    (println (colorize :cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
    (println (colorize :cyan "SPLITTING PROPERTIES"))
    (println (colorize :cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
    (let [prop-groups (split-properties properties)
          category-stats (atom {})]
      (doseq [[category props] prop-groups]
        (swap! category-stats assoc-in [category :properties] (count props))
        (write-module category "properties" {:properties (into {} props)}))

      ;; Split classes by category
      (println (colorize :cyan "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
      (println (colorize :cyan "SPLITTING CLASSES"))
      (println (colorize :cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
      (let [class-groups (split-classes classes)]
        (doseq [[category clss] class-groups]
          (swap! category-stats assoc-in [category :classes] (count clss))
          (write-module category "classes" {:classes (into {} clss)})))

      ;; Create READMEs
      (println (colorize :cyan "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
      (println (colorize :cyan "CREATING DOCUMENTATION"))
      (println (colorize :cyan "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"))
      (doseq [[category stats] @category-stats]
        (create-readme category stats)
        (println (colorize :green (str "  ✅ source/" category "/README.md")))))

    (println (colorize :green "\n✅ Split complete!"))
    (println (colorize :yellow "\n💡 Next steps:"))
    (println "  1. Review: tree source/ (or ls -R source/)")
    (println "  2. Build: bb scripts/build.clj full")
    (println "  3. Test: ./scripts/validate.sh build/logseq_db_Templates_full.edn")))

;; Run
(def input (or (first *command-line-args*) "archive/pre-modular/logseq_db_Templates.edn"))

(if (.exists (io/file input))
  (split-template input)
  (do
    (println (colorize :red (str "❌ Error: File not found: " input)))
    (println (colorize :yellow "\n💡 Make sure you've exported from Logseq using ./scripts/export.sh"))
    (println (colorize :yellow "   The file should be at: archive/pre-modular/logseq_db_Templates.edn"))
    (System/exit 1)))
