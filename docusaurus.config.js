import { themes as prismThemes } from 'prism-react-renderer';

const config = {
  title: 'apimesh',
  tagline: 'integrate every api',
  favicon: 'img/favicon.ico',

  url: 'https://apimesh.io',
  baseUrl: '/',

  organizationName: 'neuralmesh',
  projectName: 'apimesh',

  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',

  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      '@docusaurus/preset-classic',
      {
        docs: false,
        blog: false, 
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      },
    ],
  ],

  themeConfig: {
    image: 'img/docusaurus-social-card.jpg',
    navbar: {
      title: 'apimesh',
      logo: {
        alt: 'apimesh Logo',
        src: 'img/logo.svg',
      },
      items: [
        { to: '/blog', label: 'Blog', position: 'left' },
      ],
    },
    footer: {
      style: 'dark',
      links: [
        {
          title: 'More',
          items: [
            {
              label: 'GitHub',
              href: 'https://github.com/neuralmesh/apimesh',
            },
          ],
        },
      ],
      copyright: `Copyright © ${new Date().getFullYear()} Martin Christoph Frank. Built with Docusaurus.`,
    },
    prism: {
      theme: prismThemes.github,
      darkTheme: prismThemes.dracula,
    },
  },
};

export default config;

