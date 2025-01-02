import { sidebar } from "vuepress-theme-hope";

export default sidebar({
  "/": [
    "",
    {
      text: "Kedôm Lore",
      icon: "scroll",
      prefix: "docs/",
      link: "docs/",
      children: "structure",
    },
  ],
});
