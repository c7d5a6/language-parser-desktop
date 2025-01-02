import { defineAsyncComponent } from 'vue'

export default {
  enhance: ({ app }) => {    
      app.component("CommonFeatures", defineAsyncComponent(() => import("/Users/c7d5a6/projects/language_parser_desktop/docs/.vuepress/components/CommonFeatures.vue")))
  },
}
