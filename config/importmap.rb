# Pin npm packages by running ./bin/importmap

# config/importmap.rb
pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# ✅ Correct pins for Bootstrap + Popper.js from jsDelivr CDN
pin "@popperjs/core", to: "https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/esm/index.js"
pin "bootstrap",      to: "https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.esm.min.js"
pin "mapbox-gl", to: "https://ga.jspm.io/npm:mapbox-gl@3.1.2/dist/mapbox-gl.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.1.0/nodelibs/browser/process-production.js"
pin "@algolia/autocomplete-js", to: "https://ga.jspm.io/npm:@algolia/autocomplete-js@1.19.2/dist/esm/index.js"
pin "@algolia/autocomplete-core", to: "https://ga.jspm.io/npm:@algolia/autocomplete-core@1.19.2/dist/esm/index.js"
pin "@algolia/autocomplete-plugin-algolia-insights", to: "https://ga.jspm.io/npm:@algolia/autocomplete-plugin-algolia-insights@1.19.2/dist/esm/index.js"
pin "@algolia/autocomplete-preset-algolia", to: "https://ga.jspm.io/npm:@algolia/autocomplete-preset-algolia@1.19.2/dist/esm/index.js"
pin "@algolia/autocomplete-shared", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.19.2/dist/esm/index.js"
pin "@algolia/autocomplete-shared/dist/esm/core", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.19.2/dist/esm/core/index.js"
pin "@algolia/autocomplete-shared/dist/esm/js", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.19.2/dist/esm/js/index.js"
pin "@algolia/autocomplete-shared/dist/esm/preset-algolia/algoliasearch", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.19.2/dist/esm/preset-algolia/algoliasearch.js"
pin "@algolia/autocomplete-shared/dist/esm/preset-algolia/createRequester", to: "https://ga.jspm.io/npm:@algolia/autocomplete-shared@1.19.2/dist/esm/preset-algolia/createRequester.js"
pin "htm", to: "https://ga.jspm.io/npm:htm@3.1.1/dist/htm.module.js"
pin "preact", to: "https://ga.jspm.io/npm:preact@10.27.1/dist/preact.module.js"
