<template>
  <v-app :style="{background: $vuetify.theme.themes[theme].background}">
    <v-system-bar
      height="40"
      fixed
      style="background-color: #EEEEEE; z-index: 15000;"
    >
      <v-container
        v-if="!$route?.name?.includes('register') && !$route?.name?.includes('auth')"
        class="pl-6 d-flex justify-end align-center"
      >
        <div class="mr-3">
          {{ $t('help') }}
        </div>
        <div class="divider-vertical" />
        <div class="d-flex justify-space-between align-center ml-3 mr-3">
          <div class="d-flex justify-space-between align-center">
            <div class="mr-2">{{$t('language')}}</div>
            <v-menu offset-y class="pa-0">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  text
                  v-bind="attrs"
                  v-on="on"
                  style="font-weight: 400; font-size: 12px; line-height: 20px; letter-spacing: normal; color: #616161; text-transform: none;"
                  class="px-1"
                >
                  <div
                    v-if="$i18n.locale === 'en'"
                    class="d-flex align-center"
                  >
                    <img
                      width="22px"
                      height="16px"
                      src="../static/flag_en.png"
                      alt="EN"
                      class="mr-2"
                    >
                    <span>English</span>
                    <v-icon>mdi-menu-down</v-icon>
                  </div>
                  <div
                    v-if="$i18n.locale === 'ru'"
                    class="d-flex align-center"
                  >
                    <img
                      width="22px"
                      height="16px"
                      src="../static/flag_ru.png"
                      alt="RU"
                      class="mr-2"
                    >
                    <span>Русский</span>
                    <v-icon>mdi-menu-down</v-icon>
                  </div>
                  <div
                    v-if="$i18n.locale === 'ch'"
                    class="d-flex align-center"
                  >
                    <img
                      width="22px"
                      height="16px"
                      src="../static/flag_ch.png"
                      alt="CH"
                      class="mr-2"
                    >
                    <span>Русский</span>
                    <v-icon>mdi-menu-down</v-icon>
                  </div>
                </v-btn>
              </template>
              <v-list>
                <v-list-item
                  class="list-elem"
                  @click="switchLang('en')"
                >
                  <v-list-item-title>
                    <img
                      width="22px"
                      height="16px"
                      src="../static/flag_en.png"
                      alt="EN"
                      class="mr-2"
                    >
                    English
                  </v-list-item-title>
                </v-list-item>
                <v-list-item
                  class="list-elem"
                  @click="switchLang('ru')"
                >
                  <v-list-item-title>
                    <img
                      width="22px"
                      height="16px"
                      src="../static/flag_ru.png"
                      alt="RU"
                      class="mr-2"
                    >
                    Русский
                  </v-list-item-title>
                </v-list-item>
                <v-list-item
                  class="list-elem"
                  @click="switchLang('ch')"
                >
                  <v-list-item-title>
                    <img
                      width="22px"
                      height="16px"
                      src="../static/flag_ch.png"
                      alt="CH"
                      class="mr-2"
                    >
                    中國人
                  </v-list-item-title>
                </v-list-item>
              </v-list>
            </v-menu>
          </div>
          <div class="d-flex justify-space-between align-center ml-3">
            <div class="mr-2">{{ $t('currency') }}</div>
            <v-menu offset-y class="pa-0">
              <template v-slot:activator="{ on, attrs }">
                <v-btn
                  text
                  v-bind="attrs"
                  v-on="on"
                  style="font-weight: 400; font-size: 12px; line-height: 20px; letter-spacing: normal; color: #616161; text-transform: none;"
                  class="px-1"
                >
                  <img
                    v-if="currency.code === 'RUB'"
                    width="22px"
                    height="16px"
                    src="../static/flag_ru.png"
                    alt="RU"
                    class="mr-2"
                  >
                  <img
                    v-if="currency.code === 'USD'"
                    width="22px"
                    height="16px"
                    src="../static/flag_en.png"
                    alt="RU"
                    class="mr-2"
                  >
                  <img
                    v-if="currency.code === 'CNY'"
                    width="22px"
                    height="16px"
                    src="../static/flag_ch.png"
                    alt="RU"
                    class="mr-2"
                  >
                  <span>{{ currency.code }}</span>
                  <v-icon>mdi-menu-down</v-icon>
                </v-btn>
              </template>
              <v-list>
                <v-list-item
                  class="list-elem"
                  @click="switchCurrency('USD')"
                >
                  <v-list-item-title>
                    <img
                      width="22px"
                      height="16px"
                      src="../static/flag_usa.png"
                      alt="USD"
                      class="mr-2"
                    >
                    USD
                  </v-list-item-title>
                </v-list-item>
                <v-list-item
                  class="list-elem"
                  @click="switchCurrency('RUB')"
                >
                  <v-list-item-title>
                    <img
                      width="22px"
                      height="16px"
                      src="../static/flag_ru.png"
                      alt="RU"
                      class="mr-2"
                    >
                    RUB
                  </v-list-item-title>
                </v-list-item>
                <v-list-item
                  class="list-elem"
                  @click="switchCurrency('CNY')"
                >
                  <v-list-item-title>
                    <img
                      width="22px"
                      height="16px"
                      src="../static/flag_ch.png"
                      alt="CH"
                      class="mr-2"
                    >
                    元
                  </v-list-item-title>
                </v-list-item>
              </v-list>
            </v-menu>
          </div>
        </div>
        <div class="divider-vertical" />

        <div
          v-if="authorised && user"
          class="ml-3"
        >
          <v-menu offset-y class="pa-0">
            <template v-slot:activator="{ on, attrs }">
              <v-btn
                text
                v-bind="attrs"
                v-on="on"
                style="font-weight: 400; font-size: 12px; line-height: 20px; letter-spacing: normal; color: #616161; text-transform: none;"
                class="px-1"
              >
                <v-icon>mdi-account</v-icon>
                <span v-if="user.email">{{ user.email }}</span>
                <v-icon>mdi-menu-down</v-icon>
              </v-btn>
            </template>
            <v-list>
              <v-list-item
                class="list-elem"
                @click="doLogout()"
              >
                <v-list-item-title>
                  {{ $t('logout') }}
                </v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </div>

        <div
          v-else
          class="ml-3"
        >
          <NuxtLink
            to="/auth"
            style="text-decoration: none; font-size: 14px;"
          >
            {{ $t('login') }}
          </NuxtLink>
        </div>
      </v-container>

      <v-container
        v-if="$route?.name?.includes('register') || $route?.name?.includes('auth')"
        class="d-flex justify-end align-center"
        style="width: 960px;"
      >
        <div class="d-flex justify-space-between align-center">
          <div class="mr-2">{{$t('language')}}</div>
          <v-menu offset-y class="pa-0">
            <template v-slot:activator="{ on, attrs }">
              <v-btn
                text
                v-bind="attrs"
                v-on="on"
                style="font-weight: 400; font-size: 12px; line-height: 20px; letter-spacing: normal; color: #616161; text-transform: none;"
                class="px-1"
              >
                <div
                  v-if="$i18n.locale === 'en'"
                  class="d-flex align-center"
                >
                  <img
                    width="22px"
                    height="16px"
                    src="../static/flag_en.png"
                    alt="EN"
                    class="mr-2"
                  >
                  <span>English</span>
                  <v-icon>mdi-menu-down</v-icon>
                </div>
                <div v-if="$i18n.locale === 'ru'">
                  <img
                    width="22px"
                    height="16px"
                    src="../static/flag_ru.png"
                    alt="RU"
                    class="mr-2"
                  >
                  <span>Русский</span>
                  <v-icon>mdi-menu-down</v-icon>
                </div>
                
              </v-btn>
            </template>
            <v-list>
              <v-list-item class="list-elem" @click="switchLang('en')">
                <v-list-item-title>
                  <img
                    width="22px"
                    height="16px"
                    src="../static/flag_en.png"
                    alt="EN"
                    class="mr-2"
                  >
                  English
                </v-list-item-title>
              </v-list-item>
              <v-list-item class="list-elem" @click="switchLang('ru')">
                <v-list-item-title>
                  <img
                    width="22px"
                    height="16px"
                    src="../static/flag_ru.png"
                    alt="RU"
                    class="mr-2"
                  >
                  Русский
                </v-list-item-title>
              </v-list-item>
              <v-list-item class="list-elem">
                <v-list-item-title>
                  <img
                    width="22px"
                    height="16px"
                    src="../static/flag_ch.png"
                    alt="CH"
                    class="mr-2"
                  >
                  中國人
                </v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </div>
      </v-container>
    </v-system-bar>
    <v-app-bar
      v-if="!$route?.name?.includes('register') && !$route?.name?.includes('auth')"
      app
      elevation="1"
      fixed
      style="height: 88px; transform: translateY(40px); z-index: 15000;"
      :style="{background: $vuetify.theme.themes[theme].headerBackground}"
    >
      <v-container
        class="pl-6 d-flex justify-space-between align-center"
      >
        <NuxtLink
          to="/"
          style="text-decoration: none;"
        >
          <img src="../static/logo.png" alt="China Near">
        </NuxtLink>
        <v-spacer />
        <div
          class="d-flex"
          style="position: relative; margin: 0 80px; width: 100%;"
        >
          <v-text-field
            v-model="searchString"
            dense
            height="38"
            hide-details
            :placeholder="$t('search-global')"
            class="search-input"
          />
          <v-card
            v-show="showResults"
            v-click-outside="hideResults"
            max-width="600"
            class="mx-auto"
            style="position: absolute; top: 45px;"
          >
            <v-list three-line>
              <NuxtLink
                v-for="item in searchResults"
                :key="item.id"
                :to="`/catalog/${item.id}`"
                class="search-item"
              >
                <v-list-item
                  @click="clearSearchResults()"
                >
                  <v-list-item-avatar>
                    <div
                      class="goods-image"
                      :style="`background-image: url(${item.image?.image?.url})`"
                    />
                  </v-list-item-avatar>

                  <v-list-item-content>
                    <v-list-item-title>
                      {{ item.titleEn }}
                    </v-list-item-title>
                    <v-list-item-subtitle>
                      {{ item.captionEn }}
                    </v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </NuxtLink>
            </v-list>
          </v-card>
          <v-btn
            :color="$vuetify.theme.themes[theme].headerOrange"
            :disabled="!searchString"
            depressed
            height="40"
            style="border-radius: 0px 2px 2px 0px; color: #FFFFFF; font-weight: 600; font-size: 14px; line-height: 19px; text-transform: unset;"
            @click="search()"
          >
            <v-icon
              class="mr-2"
            >
              mdi-magnify
            </v-icon>
            {{ $t('search') }}
          </v-btn>
        </div>

        <v-spacer />

        <v-btn
          :color="$vuetify.theme.themes[theme].transparent"
          class="header-btn"
          depressed
          height="40"
          @click="goToCatalog"
        >
          <v-icon
            :color="$vuetify.theme.themes[theme].headerGrey"
          >
            mdi-view-grid
          </v-icon>
          <span>{{$t('catalog')}}</span>
        </v-btn>

        <v-btn
          v-if="authorised"
          :color="$vuetify.theme.themes[theme].transparent"
          class="header-btn"
          depressed
          height="40"
          @click="goToCart"
        >
          <v-badge
            v-if="cartProductsAmount"
            color="red"
            :content="cartProductsAmount"
          >
            <v-icon
              :color="$vuetify.theme.themes[theme].headerGrey"
            >
              mdi-cart
            </v-icon>
          </v-badge>
            <v-icon
              v-else
              :color="$vuetify.theme.themes[theme].headerGrey"
            >
              mdi-cart
            </v-icon>
          <span>{{$t('cart')}}</span>
        </v-btn>

        <v-btn
          v-if="authorised"
          :color="$vuetify.theme.themes[theme].transparent"
          class="header-btn"
          depressed
          height="40"
          @click="goToGoods"
        >
          <!-- <v-badge
            color="red"
            content="57"
          > -->
            <v-icon
              :color="$vuetify.theme.themes[theme].headerGrey"
            >
              mdi-view-carousel
            </v-icon>
          <!-- </v-badge> -->
          <span>{{$t('my-goods')}}</span>
        </v-btn>

        <v-btn
          v-if="authorised"
          :color="$vuetify.theme.themes[theme].transparent"
          class="header-btn"
          depressed
          height="40"
          @click="goToOrders"
        >
          <!-- <v-badge
            color="red"
            content="15"
          > -->
            <v-icon
              :color="$vuetify.theme.themes[theme].headerGrey"
            >
              mdi-shopping
            </v-icon>
          <!-- </v-badge> -->
          <span>{{$t('my-orders')}}</span>
        </v-btn>

        <v-btn
          v-if="authorised"
          :color="$vuetify.theme.themes[theme].transparent"
          class="header-btn"
          depressed
          height="40"
          @click="goToChat"
        >
          <!-- <v-badge
            color="red"
            content="1"
          > -->
            <v-icon
              :color="$vuetify.theme.themes[theme].headerGrey"
            >
              mdi-forum
            </v-icon>
          <!-- </v-badge> -->
          <span>{{$t('my-chats')}}</span>
        </v-btn>

        <!-- <v-btn
          icon
          @click.stop="sideDrawer = !sideDrawer"
        >
          <v-icon>mdi-menu</v-icon>
        </v-btn> -->
      </v-container>
    </v-app-bar>
    <v-main>
      <v-container>
        <Nuxt />
      </v-container>
    </v-main>
    <v-navigation-drawer
      v-model="sideDrawer"
      right
      temporary
      fixed
    >
      <v-list>
        <v-list-item>
          <v-list-item-title>Right menu</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-footer
      class="d-flex justify-center"
      style="height: 88px;"
      :style="{background: $vuetify.theme.themes[theme].footerBackground}"
    >
      <span
        style="font-weight: 400; font-size: 16px; line-height: 24px; text-align: center; color: #616161;">
        {{ $t('not-a-public-offer') }}
        (c) Evil Tech,
        {{ new Date().getFullYear() }}
      </span>
    </v-footer>
  </v-app>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

export default {
  name: 'DefaultLayout',
  data () {
    return {
      miniVariant: false,
      sideDrawer: false,
      searchString: '',
      searchResults: [],
      showResults: false,
    }
  },
  computed: {
    ...mapGetters({
      user: 'user',
      authorised: 'authorised',
      cartProductsAmount: 'cartProductsAmount',
      currency: 'currency',
      currencyRates: 'currencyRates',
    }),
    theme () {
      return (this.$vuetify.theme.dark) ? 'dark' : 'light'
    },
  },
  async mounted () {
    this.checkAuth();
    await this.getCart();
    await this.getCurrencyRates();
  },
  methods: {
    ...mapActions({
      setAuth: 'login',
      logout: 'logout',
      setCart: 'setCart',
      setCurrencyRates: 'setCurrencyRates',
      setCurrency: 'setCurrency',
    }),
    checkAuth () {
      const auth = localStorage.getItem('auth');

      if (auth && auth !== 'null') {
        this.setAuth(JSON.parse(auth));
      }
    },
    clearSearchResults () {
      this.showResults = false;
    },
    hideResults () {
      this.showResults = false;
    },
    async search () {
      console.log('--> Search')

      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            products (
              where: {
                OR: [
                  { titleRu: { contains: "ge" } }
                  { titleEn: { contains: "ge" } }
                  { titleCh: { contains: "ge" } }
                ]
                AND: [
                  { isActive: { equals: true } }
                ]
              }
            ) {
              id
              titleEn
              titleRu
              titleCh
              captionRu
              captionEn
              captionCh
              descriptionRu
              descriptionEn
              descriptionCh
              balance
              intervals
              isActive
              author {
                id
              }
              seller {
                id
                companyName
                companyMarketNameRu
                companyMarketNameEn
              }
              image {
                image {
                  filesize
                  width
                  height
                  extension
                  url
                }
              }
              images {
                image {
                  filesize
                  width
                  height
                  extension
                  url
                }
              }
              category {
                id
                code
                titleEn
                titleRu
                titleCh
              }
              subCategory {
                id
                code
                titleEn
                titleRu
                titleCh
              }
              subSubCategory {
                id
                code
                titleEn
                titleRu
                titleCh
              }
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      if (response?.data?.data?.products) {
        this.searchResults = response.data.data.products;
        this.showResults = true;
      }

      this.loading = false;
    },
    async getCart () {
      const graphqlQuery = {
        query: `
          query {
            cart (
              where: {
                userId: "${this.user.id}"
              }
            ) {
              id
              products
              userId
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get cart response', response);

      const cart = response?.data?.data?.cart;

      if (cart && cart.products) {
        cart.products = JSON.parse(cart.products.replace(/'/g, '"'));
        this.setCart(cart);
      }
    },
    async getCurrencyRates () {
      const graphqlQuery = {
        query: `
          query {
            currencyRates {
              code
              value
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get currency rates response', response);

      const currencyRates = response?.data?.data?.currencyRates;

      this.setCurrencyRates(currencyRates)
      this.setCurrency(currencyRates[0])
    },
    doLogout () {
      this.logout();
      this.$router.push({ name: 'auth' });
    },
    goToCatalog () {
      this.$router.push({ name: 'catalog' });
    },
    goToCart () {
      this.$router.push({ name: 'cart' });
    },
    goToChat () {
      this.$router.push({ name: 'chat' });
    },
    goToOrders () {
      this.$router.push({ name: 'orders' });
    },
    goToGoods () {
      this.$router.push({ name: 'goods' });
    },
    switchLang (locale) {
      this.$i18n.setLocale(locale);
    },
    switchCurrency (curr) {
      if (!curr) return;

      const currency = this.currencyRates.find(c => c.code === curr);

      console.log(currency);

      if (currency) {
        this.setCurrency(currency);
      }
    }
  }
}
</script>

<style>
@media (min-width: 960px) {
  .container {
    max-width: 900px;
  }
}
@media (min-width: 1264px) {
  .container {
    max-width: 1000px;
  }
}
@media (min-width: 1700px) {
  .container {
    max-width: 1440px;
  }
}

.v-application {
  font-family: 'Open Sans';
  font-style: normal;
  font-weight: 400;
  font-size: 16px;
  line-height: 18px;
}

.top-bar {
  background-color: #FFC600;
  height: 40px;
  position: absolute;
  top: 0;
  left: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
}


.v-list.v-sheet {
  padding: 0;
}

.list-elem {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  cursor: pointer;
  transition: all 0.2s;
  height: 40px !important;
}

.v-list-item--disabled {
  background-color: #e2e2e2;
}

.list-elem .v-list-item__title {
  font-weight: 400;
  font-size: 12px;
  line-height: 16px;
  color: #616161;
}

.list-elem:hover {
  background-color: rgba(255, 117, 25, 0.1);
}

.list-elem:hover .v-list-item__title {
  cursor: pointer;
  color: rgb(255, 117, 25);
}

.v-toolbar__content {
  min-height: 100%;
}

.search-input {
  border: 1px solid #FF7419;
  border-top-left-radius: 2px;
  border-bottom-left-radius: 2px;
  padding-left: 16px;
}

.search-input input {
  font-weight: 400;
  font-size: 13px;
  line-height: 16px;
  letter-spacing: 0.02em;
  color: #BDBDBD;
}

.search-input .v-input__slot:before,
.search-input .v-input__slot:after {
  display: none;
}

button.header-btn.v-btn:hover i,
button.header-btn.v-btn:hover span {
  color: #FF7419 !important;
}

button.header-btn.v-btn:hover .v-badge__badge {
  color: #FFFFFF !important;
}

button.header-btn.v-btn:hover::before {
  display: none;
}

button.header-btn.v-btn .v-btn__content {
  display: flex;
  flex-direction: column;
}

button.header-btn.v-btn .v-btn__content i {
  font-size: 20px;
}

button.header-btn.v-btn .v-btn__content span {
  font-style: normal;
  font-weight: 400;
  font-size: 12px;
  line-height: 16px;
  text-align: center;
  letter-spacing: 0.01em;
  color: #616161;
  text-transform: capitalize;
}

button.header-btn.v-btn .v-btn__content span.v-badge__badge {
  font-style: normal;
  font-weight: 700;
  font-size: 10px;
  line-height: 10px;
  display: flex;
  justify-content: center;
  align-items: center;
  text-align: center;
  letter-spacing: 0.01em;
  color: #FFFFFF;
  height: 18px;
  min-width: 18px;
}

div.divider-vertical {
  width: 1px;
  height: 24px;
  margin-top: 2px;
  background: #E0E0E0;
}

.v-system-bar {
  font-style: normal;
  font-weight: 400;
  font-size: 12px;
  line-height: 20px;
  letter-spacing: 0.02em;
  color: #616161;
}
</style>

<style scoped>
.goods-image {
  height: 100%;
  width: 100%;
  background-color: #ffffff;
  background-position: center;
  background-size: contain;
  background-repeat: no-repeat;
}

.search-item {
  text-decoration: none;
}

.search-item .v-list-item {
  transition: all 0.28s;
}

.search-item:hover .v-list-item {
  background-color: #ffd9c0 !important;
}
</style>
