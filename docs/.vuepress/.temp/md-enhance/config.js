import { defineClientConfig } from "vuepress/client";
import { hasGlobalComponent } from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/@vuepress/helper/lib/client/index.js";
import { VPCard } from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/compact/index.js";
import CodeTabs from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/components/CodeTabs.js";
import { CodeGroup, CodeGroupItem } from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/compact/index.js";
import CodeDemo from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/components/CodeDemo.js";
import MdDemo from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/components/MdDemo.js";
import "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/styles/figure.scss";
import { useHintContainers } from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/composables/useHintContainers.js";
import "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/styles/hint/index.scss";
import Playground from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/components/Playground.js";
import Tabs from "/Users/c7d5a6/projects/language_parser_desktop/node_modules/vuepress-theme-hope/node_modules/vuepress-plugin-md-enhance/lib/client/components/Tabs.js";

export default defineClientConfig({
  enhance: ({ app }) => {
    if(!hasGlobalComponent("VPCard", app)) app.component("VPCard", VPCard);
    app.component("CodeTabs", CodeTabs);
    if(!hasGlobalComponent("CodeGroup", app)) app.component("CodeGroup", CodeGroup);
    if(!hasGlobalComponent("CodeGroupItem", app)) app.component("CodeGroupItem", CodeGroupItem);
    app.component("CodeDemo", CodeDemo);
    app.component("MdDemo", MdDemo);
    app.component("Playground", Playground);
    app.component("Tabs", Tabs);
  },
  setup: () => {
useHintContainers();
  }
});
