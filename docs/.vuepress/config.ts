import { path } from '@vuepress/utils' 
import { viteBundler } from '@vuepress/bundler-vite'
import { registerComponentsPlugin } from '@vuepress/plugin-register-components'
import { defineUserConfig } from "vuepress";
import theme from "./theme.js";

export default defineUserConfig({
  base: "/",

  lang: "en-US",
  title: "PHDocs",
  description: "Ph lib",


  theme,
  bundler: viteBundler({
      viteOptions: {},
      vuePluginOptions: {},
  }),
  plugins: [
      registerComponentsPlugin({
          componentsDir: path.resolve(__dirname, './components'),
      }),
  ],

  // Enable it with pwa
  // shouldPrefetch: false,
});
