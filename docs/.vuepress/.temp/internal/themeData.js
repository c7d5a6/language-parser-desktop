export const themeData = JSON.parse("{\"encrypt\":{},\"author\":{\"name\":\"OwlbearDM\",\"url\":\"https://owlbeardm.com\"},\"darkmode\":\"enable\",\"logo\":\"/logo.png\",\"repo\":\"owlbeardm/kedom\",\"docsDir\":\"src\",\"footer\":\"Default footer\",\"displayFooter\":true,\"locales\":{\"/\":{\"lang\":\"en-US\",\"navbarLocales\":{\"langName\":\"English\",\"selectLangAriaLabel\":\"Select language\"},\"metaLocales\":{\"author\":\"Author\",\"date\":\"Writing Date\",\"origin\":\"Original\",\"views\":\"Page views\",\"category\":\"Category\",\"tag\":\"Tag\",\"readingTime\":\"Reading Time\",\"words\":\"Words\",\"toc\":\"On This Page\",\"prev\":\"Prev\",\"next\":\"Next\",\"lastUpdated\":\"Last update\",\"contributors\":\"Contributors\",\"editLink\":\"Edit this page\",\"print\":\"Print\"},\"outlookLocales\":{\"themeColor\":\"Theme Color\",\"darkmode\":\"Theme Mode\",\"fullscreen\":\"Full Screen\"},\"routeLocales\":{\"skipToContent\":\"Skip to main content\",\"notFoundTitle\":\"Page not found\",\"notFoundMsg\":[\"There’s nothing here.\",\"How did we get here?\",\"That’s a Four-Oh-Four.\",\"Looks like we've got some broken links.\"],\"back\":\"Go back\",\"home\":\"Take me home\",\"openInNewWindow\":\"Open in new window\"},\"navbar\":[\"/\",{\"text\":\"Demo\",\"icon\":\"scroll\",\"link\":\"/api-examples\"},{\"text\":\"Docs\",\"icon\":\"scroll\",\"link\":\"/docs/\"}],\"sidebar\":{\"/\":[\"\",{\"text\":\"Kedôm Lore\",\"icon\":\"scroll\",\"prefix\":\"docs/\",\"link\":\"docs/\",\"children\":\"structure\"}]}}}}")

if (import.meta.webpackHot) {
  import.meta.webpackHot.accept()
  if (__VUE_HMR_RUNTIME__.updateThemeData) {
    __VUE_HMR_RUNTIME__.updateThemeData(themeData)
  }
}

if (import.meta.hot) {
  import.meta.hot.accept(({ themeData }) => {
    __VUE_HMR_RUNTIME__.updateThemeData(themeData)
  })
}
