export const redirects = JSON.parse("{}")

export const routes = Object.fromEntries([
  ["/api-examples.html", { loader: () => import(/* webpackChunkName: "api-examples.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/api-examples.html.js"), meta: {"t":"Demo"} }],
  ["/", { loader: () => import(/* webpackChunkName: "index.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/index.html.js"), meta: {"t":""} }],
  ["/markdown-examples.html", { loader: () => import(/* webpackChunkName: "markdown-examples.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/markdown-examples.html.js"), meta: {"t":"Language Parsser"} }],
  ["/docs/", { loader: () => import(/* webpackChunkName: "docs_index.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/docs/index.html.js"), meta: {"t":""} }],
  ["/docs/grammar/grammatical-categories.html", { loader: () => import(/* webpackChunkName: "docs_grammar_grammatical-categories.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/docs/grammar/grammatical-categories.html.js"), meta: {"t":"Grammatical Categories"} }],
  ["/docs/grammar/", { loader: () => import(/* webpackChunkName: "docs_grammar_index.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/docs/grammar/index.html.js"), meta: {"t":"Grammar"} }],
  ["/docs/grammar/word-classes.html", { loader: () => import(/* webpackChunkName: "docs_grammar_word-classes.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/docs/grammar/word-classes.html.js"), meta: {"t":"Word Classes"} }],
  ["/docs/languages/grammatical-categories.html", { loader: () => import(/* webpackChunkName: "docs_languages_grammatical-categories.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/docs/languages/grammatical-categories.html.js"), meta: {"t":"Grammatical Categories"} }],
  ["/docs/languages/", { loader: () => import(/* webpackChunkName: "docs_languages_index.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/docs/languages/index.html.js"), meta: {"t":""} }],
  ["/docs/languages/word-classes.html", { loader: () => import(/* webpackChunkName: "docs_languages_word-classes.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/docs/languages/word-classes.html.js"), meta: {"t":"Word Classes"} }],
  ["/404.html", { loader: () => import(/* webpackChunkName: "404.html" */"/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/.temp/pages/404.html.js"), meta: {"t":""} }],
]);

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updateRoutes) {
    __VUE_HMR_RUNTIME__.updateRoutes(routes)
  }
  if (__VUE_HMR_RUNTIME__.updateRedirects) {
    __VUE_HMR_RUNTIME__.updateRedirects(redirects)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ routes, redirects }) => {
    __VUE_HMR_RUNTIME__.updateRoutes(routes)
    __VUE_HMR_RUNTIME__.updateRedirects(redirects)
  })
}
