import Vue from 'vue';
import assets from '../classes/assets';

Vue.prototype.$assets = assets;
Vue.prototype.$scrollTop = function () {
  window.scrollTo({
    top: 600,
    left: 0,
    behavior: 'smooth'
  })
}
