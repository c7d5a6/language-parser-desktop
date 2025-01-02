import { defineClientConfig } from "vuepress/client";
import { hasGlobalComponent } from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/@vuepress/helper/lib/client/index.js";

import { useScriptTag } from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/@vueuse/core/index.mjs";
import Badge from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-components/lib/client/components/Badge.js";
import FontIcon from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-components/lib/client/components/FontIcon.js";

import "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-components/lib/client/styles/sr-only.scss";

export default defineClientConfig({
  enhance: ({ app }) => {
    if(!hasGlobalComponent("Badge")) app.component("Badge", Badge);
    if(!hasGlobalComponent("FontIcon")) app.component("FontIcon", FontIcon);
    
  },
  setup: () => {
    useScriptTag(
  `https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6/js/brands.min.js`,
  () => {},
  { attrs: { "data-auto-replace-svg": "nest" } }
);

    useScriptTag(
  `https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6/js/solid.min.js`,
  () => {},
  { attrs: { "data-auto-replace-svg": "nest" } }
);

    useScriptTag(
  `https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6/js/fontawesome.min.js`,
  () => {},
  { attrs: { "data-auto-replace-svg": "nest" } }
);

  },
  rootComponents: [

  ],
});
