<template>
  <div>
    <div
      v-if="loading || !data.length"
      class="goods-cards-container"
    >
      <div
        style="width: 100%;"
        class="d-flex justify-center pt-10"
      >
        <v-progress-circular
          indeterminate
          color="primary"
        />
      </div>
    </div>
    <div
      v-else
      class="goods-cards-container"
    >
      <div
        v-for="item in data"
        :key="item.id"
        class="card-holder"
      >
        <v-card
          class="simple-goods-block d-flex flex-row"
          flat
          @click="openGoods(item.id)"
        >
          <div
            class="goods-image mr-7"
            :style="`background-image: url(${item.image?.url})`"
          />
          <v-card-text class="d-flex flex-column justify-space-between">
            <div>
              <span
                class="goods-title mb-2"
              >
                {{ item.title }}
              </span>
              <span
                class="goods-text"
              >
                {{ item.caption }}
              </span>
            </div>
            
            <div>
              <span
                class="goods-text"
              >
                {{ $t('seller') }}:
                <a color="blue" href="/">{{ item.seller?.companyMarketNameEn }}</a> 
              </span>
              <br>
              <span
                class="goods-text"
              >
                {{ $t('in-stock') }}: {{ item.balance }}
              </span>
            </div>
          </v-card-text>
          <v-card-actions
            class="d-flex flex-column justify-space-between"
          >
            <span
              class="goods-price-minmax"
            >
              {{ minPrice(item) }} - {{ maxPrice(item) }} ₽
            </span>
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
  </div>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import text from '@/utils/mixins/text';

export default {
  name: 'ViewsList',
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
    }),
  },
  methods: {
    ...mapActions({
      addProductToCart: 'addProductToCart',
    }),
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

      console.log('Update cart response', response);
    },
    openGoods (id) {
      this.$emit('open-goods', id)
    },
    minPrice (item) {
      return item.intervals[item.intervals.length - 1].price;
    },
    maxPrice (item) {
      return item.intervals[0].price;
    },
  }
}
</script>

<style scoped>
  .v-card__actions {
    padding: 0px;
    min-width: 170px;
  }

  .v-card__actions > button.v-btn.btn-common {
    padding: 12px 32px;
    border-radius: 2px;
    height: unset;
    width: unset;
    min-width: unset;
    font-weight: 700;
    font-size: 14px;
    line-height: 16px;
    letter-spacing: 0.02em;color: #FFFFFF;
    text-transform: none;
  }
</style>

<style lang="scss" scoped>

.goods-cards-container {
  display: flex;
  flex-direction: column;
}

.card-holder {
  height: 200px;
  width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;

  &:after {
    position: absolute;
    content: "";
    display: block;
    height: 1px;
    width: 96%;
    bottom: 0px;
    left: 2%;
    background-color: #E0E0E0;
  }
}

.simple-goods-block {
  width: 100%;
  min-height: 192px;
  background: #FFFFFF;
  padding: 16px 24px;
  transition: all linear .18s;
  border-radius: 0;
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

  .goods-image {
    width: 160px;
    height: 160px;
    min-width: 160px;
    min-height: 160px;
    max-width: 160px;
    max-height: 160px;
    // border: 1px solid #EEEEEE;
    border-radius: 4px;
    background-position: center;
    background-size: contain;
    background-repeat: no-repeat;
  }

  .v-card__text {
    padding: 0;
    background-color: transparent !important;

    span {
      font-size: 14px;
      &.visited {
        color: var(--accent-4) !important;
      }
    }

    .goods-price-minmax {
      font-weight: 600;
      font-size: 20px;
      line-height: 27px;
      text-align: right;
      letter-spacing: 0.02em;
      color: #424242;
    }

    .goods-title {
      max-height: 38px;
      display: -webkit-box;
      -webkit-line-clamp: 2;
      -webkit-box-orient: vertical;
      overflow: hidden;
      font-weight: 600;
      font-size: 14px;
      line-height: 19px;
      color: #616161;
    }

    .goods-text {
      font-style: normal;
      font-weight: 400;
      font-size: 12px;
      line-height: 16px;
      color: #616161;
    }
  }
}

.skeleton-goods-card {
  padding: 20px;
}
</style>
