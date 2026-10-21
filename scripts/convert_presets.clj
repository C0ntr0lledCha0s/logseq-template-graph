#!/usr/bin/env bb
;; One-time: rewrites source/presets/*.edn from module-level to class-level presets.
(require '[template-graph.presets :as presets])
(presets/convert-preset-files!)
(println "converted source/presets/*.edn")
