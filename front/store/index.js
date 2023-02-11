import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

const store = () => new Vuex.Store({
  state: {
    user: {},
    authorised: false,
    sessionToken: '',
    cart: {
      id: '',
      products: []
    }
  },
  getters: {
    authorised: (state) => state.authorised,
    user: (state) => state.user,
    cart: (state) => state.cart,
    cartProducts: (state) => state.cart.products,
    cartProductsAmount: (state) => state.cart.products?.length,
  },
  mutations: {
    LOGIN(state, data) {
      state.user = data.user;
      state.sessionToken = data.sessionToken;
      state.authorised = true;
    },
    LOGOUT(state) {
      state.user = {};
      state.sessionToken = '';
      state.authorised = true;
    },
    ADD_PRODUCT_TO_CART(state, product) {
      state.cart.products = [ ...state.cart.products, product ];

      console.log('mutation ADD_PRODUCT_TO_CART');
      console.log(state.cart);
    },
    ADD_PRODUCTS_TO_CART(state, products) {
      state.cart.products = [ ...state.cart.products, ...products ];
    },
    REMOVE_PRODUCT_FROM_CART(state, productId) {
      state.cart.products = [ ...state.cart.products.filter(p => p.id !== productId) ];
    },
    CLEAR_CART(state) {
      state.cart.products = [];
    },
    SET_CART_PRODUCT_AMOUNT(state, { id, amount }) {
      const product = state.cart.products.find(p => p.id === id);
      product.amount = amount;
    },
    SET_CART(state, cart) {
      state.cart = cart;
    },
  },
  actions: {
    logout({ commit }) {
      commit('LOGOUT');

      localStorage.setItem('auth', null);
    },
    login({ commit }, data) {
      commit('LOGIN', data);

      localStorage.setItem('auth', JSON.stringify(data));
    },
    setCart({ commit }, cart) {
      commit('SET_CART', cart);
    },
    addProductToCart({ commit }, product) {
      commit('ADD_PRODUCT_TO_CART', product);
    },
    addProductsToCart({ commit }, products) {
      commit('ADD_PRODUCTS_TO_CART', products);
    },
    removeProductFromCart({ commit }, productId) {
      commit('REMOVE_PRODUCT_FROM_CART', productId);
    },
    setCartProductAmount({ commit }, { id, amount }) {
      commit('SET_CART_PRODUCT_AMOUNT', { id, amount });
    },
    clearCart({ commit }) {
      commit('CLEAR_CART');
    },
  },
});

export default store;
