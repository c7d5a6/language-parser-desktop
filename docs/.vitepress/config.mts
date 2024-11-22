import {defineConfig} from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
    title: "Language Parser",
    description: "A language parser project",
    base: '/language-parser-desktop/',
    themeConfig: {
        // https://vitepress.dev/reference/default-theme-config
        nav: [
            {text: 'Home', link: '/'},
            {text: 'Documentation', link: '/docs/'}
        ],

        sidebar: [
            {
                text: 'Examples',
                items: [
                    {
                        text: 'Documentation', base: 'docs', items: [
                            {
                                text: 'Grammar', base: 'docs/grammar', items: [
                                    {text: 'Word Classes', link: '/word-classes.md'},
                                    {text: 'Grammatical Categories', link: '/grammatical-categories.md'}
                                ]
                            }
                        ]
                    },
                    {text: 'Runtime API Examples', link: '/api-examples'}
                ]
            }
        ],

        socialLinks: [
            {icon: 'github', link: 'https://github.com/vuejs/vitepress'}
        ]
    }
})
