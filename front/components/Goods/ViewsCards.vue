<template>
  <div>
    <div
      v-if="loading"
      class="goods-cards-container"
      :class="{ row: row }"
    >
      <div
        v-for="item in row ? 5 : 20"
        :key="item"
        class="card-holder"
      >
        <v-skeleton-loader
          type="image, list-item, card-heading, list-item-two-line"
          class="simple-goods-card"
        />
      </div>
    </div>
    <perfect-scrollbar
      v-else
      :class="{ row: row }"
    >
      <section v-if="!data.length" class="card-holder">
        <p style="text-align: center;">В данной категории пока нет товаров :(</p>
      </section>
      <div
        class="goods-cards-container"
        :class="{ row: row }"
      >
        <div
          v-for="item in data"
          :key="item.id"
          class="card-holder"
        >
          <v-card
            class="simple-goods-card"
            flat
            style="position: relative;"
          >
            <Label
              v-if="myGood(item)"
              :value="$t('my-product')"
              color="orange"
              style="position: absolute; top: 8px; left: 8px;"
            />
            <v-card-text
              class="d-flex flex-column"
              @click="openGoods(item.id)"
            >
              <div
                class="goods-image mb-2"
                :style="`background-image: url(${item.image?.url})`"
              />
              <span
                class="goods-price-minmax mb-1"
              >
                <money-format
                  :value="minPrice(item)"
                  locale="ru"
                  :currency-code="currency.code"
                  style="display: inline-block;"
                />
                —
                <money-format
                  :value="maxPrice(item)"
                  locale="ru"
                  :currency-code="currency.code"
                  style="display: inline-block;"
                />
              </span>
              <span
                class="goods-title"
              >
                {{ getTitle(item) }}
              </span>
            </v-card-text>
            <v-card-actions>
              <v-btn
                color="primary"
                class="btn-common"
                depressed
                :disabled="isProductInCart(item)"
                @click="addToCart(item)"
              >
                {{ isProductInCart(item) ? $t('in-cart') : $t('add-to-cart') }}
              </v-btn>
            </v-card-actions>
          </v-card>
        </div>
      </div>
    </perfect-scrollbar>
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import { PerfectScrollbar } from 'vue2-perfect-scrollbar';
import MoneyFormat from 'vue-money-format';
import text from '@/utils/mixins/text';

export default {
  name: 'ViewsCards',
  components: {
    PerfectScrollbar,
    MoneyFormat,
  },
  mixins: [
    text
  ],
  props: {
    data: {
      type: Array,
      default: () => []
    },
    loading: {
      type: Boolean,
      default: () => true
    },
    row: {
      type: Boolean,
      default: false
    }
  },
  data () {
    return {
      menu: []
    }
  },
  computed: {
    ...mapGetters({
      cartProducts: 'cartProducts',
      user: 'user',
      cart: 'cart',
      currency: 'currency',
      currencyRates: 'currencyRates',
    }),
  },
  methods: {
    ...mapActions({
      addProductToCart: 'addProductToCart',
    }),
    myGood (item) {
      return item?.seller?.id === this.user?.id
    },
    getTitle (item) {
      if (this.$i18n.locale === 'ru') return item.titleRu;
      if (this.$i18n.locale === 'en') return item.titleEn;
      if (this.$i18n.locale === 'ch') return item.titleCh;
    },
    getCaption (item) {
      if (this.$i18n.locale === 'ru') return item.captionRu;
      if (this.$i18n.locale === 'en') return item.captionEn;
      if (this.$i18n.locale === 'ch') return item.captionCh;
    },
    isProductInCart (product) {
      return this.cartProducts.some(p => p.id === product.id);
    },
    addToCart (product) {
      this.addProductToCart({
        ...product,
        amount: 1
      });

      if (this.user) {
        this.handleCart();
      }
    },
    async handleCart () {
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

      console.log('Handle cart response', response);

      const cart = response?.data?.data?.cart;

      if (cart) {
        this.updateCart();
      } else {
        this.createCart();
      }
    },
    async createCart () {
      const graphqlQuery = {
        query: `
          mutation {
            createCart (
              data: {
                products: "${JSON.stringify(this.cartProducts).replace(/"/g, '\'')}",
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

      console.log('Create cart response', response);
    },
    async updateCart () {
      const graphqlQuery = {
        query: `
          mutation {
            updateCart (
              where: {
                id: "${this.cart.id}"
              }
              data: {
                products: "${JSON.stringify(this.cartProducts).replace(/"/g, '\'')}"
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

      console.log('Update cart response', response);
    },
    openGoods (id) {
      this.$emit('open-goods', id)
    },
    minPrice (item) {
      if (! item.intervals) {
        return '';
      }

      const usdPrice = item.intervals[item.intervals.length - 1].price;

      return usdPrice * parseFloat(this.currency.value);
    },
    maxPrice (item) {
      if (! item.intervals) {
        return '';
      }

      const usdPrice = item.intervals[0].price;

      return usdPrice * parseFloat(this.currency.value);
    },
  }
}
</script>

<style src="vue2-perfect-scrollbar/dist/vue2-perfect-scrollbar.css"/>

<style>
  .ps__rail-x,
  .ps__rail-y {
    display: none !important;
  }

  .ps.row {
    height: 360px;
  }

  .ps.row .ps__rail-y {
    display: none !important;
  }

  .ps.row .ps__rail-x {
    display: block !important;
    bottom: 0 !important;
    height: 5px !important;
    background-color: transparent !important;
  }

  .ps__rail-x:hover {
    background-color: transparent !important;
  }

  .ps__thumb-x {
    background-color: #FF9B00 !important;
    height: 5px !important;
  }
</style>

<style scoped>
  .v-card__actions {
    padding: 0px;
  }

  .v-card__actions > button.v-btn.btn-common {
    padding: 10px 18px;
    border-radius: 2px;
    height: unset;
    width: unset;
    min-width: unset;
    font-weight: 600;
    font-size: 10px;
    line-height: 12px;
    letter-spacing: 0.02em;color: #FFFFFF;
    text-transform: none;
  }
</style>

<style lang="scss" scoped>
@media only screen and (min-width: 480px) {
  .goods-cards-container {
    grid-template-columns: repeat(2, minmax(100px, 1fr));
  }
}

@media only screen and (min-width: 980px) {
  .goods-cards-container {
    grid-template-columns: repeat(3, minmax(200px, 1fr));
  }
}

@media only screen and (min-width: 1900px) {
  .goods-cards-container {
    grid-template-columns: repeat(5, minmax(200px, 1fr));
  }
}

.goods-cards-container {
  display: grid;
  gap: 16px;
  min-height: 300px;

  &.row {
    grid-template-columns: repeat(5, minmax(360px, 1fr)) !important;
    grid-template-rows: 370px;
    max-height: 370px;
    // overflow-y: hidden;
    // overflow-x: scroll;
  }
}

.card-holder {
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.simple-goods-card {
  min-width: 224px;
  width: 100%;
  max-width: 320px;
  height: 330px;
  background: #FFFFFF;
  border-radius: 4px;
  padding: 12px;
  transition: all linear .18s;
  box-shadow: 6px 0px 16px rgba(0, 0, 0, 0.04), 1px 2px 4px -1px rgba(0, 0, 0, 0.08) !important;
  cursor: pointer;

  &.v-skeleton-loader {
    ::v-deep {
      > div:not(.v-skeleton-loader__image) {
        background-color: transparent;
      }
      .v-skeleton-loader__image {
        height: 200px;
        width: 200px;
      }
    }
  }
  .v-card__text {
    padding: 0;
    background-color: transparent !important;

    .goods-image {
      width: 200px;
      height: 200px;
      // border: 1px solid #EEEEEE;
      border-radius: 3px;
      margin: 0 auto;
      background-position: center;
      background-size: contain;
      background-repeat: no-repeat;
    }

    span {
      font-size: 14px;
      &.visited {
        color: var(--accent-4) !important;
      }
    }

    .goods-price-minmax {
      font-size: 16px;
      line-height: 18px;
      letter-spacing: 0.01em;
      color: #333333;
    }

    .goods-title {
      height: 44px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      font-size: 12px;
      line-height: 16px;

      + span {
        height: 34px;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        line-height: 17px;
      }
    }
  }
}

.skeleton-goods-card {
  padding: 20px;
}
</style>
