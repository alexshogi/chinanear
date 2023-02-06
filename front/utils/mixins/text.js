import MarkdownIt from 'markdown-it'
import sanitizeHtml from 'sanitize-html'

const showdown = require('showdown')
const showdownOptionsDefault = {
  disableForced4SpacesIndentedSublists: true,
  simpleLineBreaks: false
}
const markdownItOptionsDefault = {
  html: true,
  linkify: true,
  typographer: true
}

export default {
  methods: {
    destructHTML (html) {
      const p = document.createElement('p')
      p.innerHTML = html
      return p.textContent
    },
    convertHTML (text, options = showdownOptionsDefault) {
      const converter = new showdown.Converter(options)
      return converter.makeHtml(text)
    },
    getDescription (text, options = markdownItOptionsDefault) {
      const MD = new MarkdownIt(options)
      return !text ? '-' : MD.renderInline(text)
    },
    unescapeHTML (escapedHTML) {
      return escapedHTML.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&')
    },
    cleanHTML (html) {
      return sanitizeHtml(html, {
        allowedAttributes: {
          'img': [ 'src', 'alt' ]
        },
        allowedTags: sanitizeHtml.defaults.allowedTags.concat([ 'img' ])
      })
    }
  }
}
