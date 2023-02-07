import Vue from 'vue';
import { format } from 'date-fns';

Vue.filter('datetime', function (value) {
  if (!value) return '';

  return format(new Date(value), 'MM.dd.yyyy HH:mm')
})

Vue.prototype.$scrollTop = function () {
  window.scrollTo({
    top: 600,
    left: 0,
    behavior: 'smooth'
  })
}
