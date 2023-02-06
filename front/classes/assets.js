export default {
  prefix: (name, locale) => {
    console.log('prefix')
    if (locale === 'en') {
      return `en/${name}`
    }

    return name;
  }
}
