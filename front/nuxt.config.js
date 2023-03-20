import colors from 'vuetify/es5/util/colors'
import customColors from './assets/colors'

const translation = require('./lang/translation')

export default {
  head: {
    titleTemplate: 'ChinaNear',
    title: 'ChinaNear',
    htmlAttrs: {
      lang: 'en'
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },
  cache: true,
  css: [],
  plugins: [
    '~/plugins/assets.js',
    { src: '~/plugins/TiptapVuetify', mode: 'client' },
  ],
  components: true,
  // target: 'server',
  buildModules: [
    '@nuxtjs/vuetify'
  ],
  modules: [
    '@nuxtjs/axios',
    ['nuxt-i18n', {
      strategy: 'no_prefix',
      locales: ['ru', 'en'],
      defaultLocale: 'ru',
      vueI18n: {
        fallbackLocale: 'en',
        messages: translation
      }
    }]
  ],
  axios: {
    baseURL: 'http://localhost:3000/api/graphql',
    // baseURL: 'http://194.58.122.11:3000/api/graphql',
    timeout: 10000,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json',
    },
  },
  server: {
    // host: '0.0.0.0',
    port: 8080
  },
  vuetify: {
    customVariables: ['~/assets/variables.scss'],
    theme: {
      dark: false,
      themes: {
        dark: {
          primary: customColors.orange.base,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3
        },
        light: {
          background: customColors.grey.base,
          headerBackground: '#FFFFFF',
          footerBackground: customColors.grey.darken1,
          headerOrange: customColors.orange.darken,
          headerGrey: customColors.grey.darken2,
          transparent: 'rgba(0,0,0,0)',
          primary: customColors.orange.base,
          red: customColors.red.base,
          appbarGrey: customColors.grey.darken3,
          accent: colors.grey.darken3,
          secondary: colors.amber.darken3,
          info: colors.teal.lighten1,
          warning: colors.amber.base,
          error: colors.deepOrange.accent4,
          success: colors.green.accent3,
          anchor: '#428BCA'
        }
      }
    }
  },
  build: {
    transpile: ['vuetify/lib', 'tiptap-vuetify']
  }
}
