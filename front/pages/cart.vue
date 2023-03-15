<template>
  <v-container
    ref="page"
    class="cart-page"
    style="margin-top: 52px;"
  >
    <v-row>
      <v-col cols="9">
        <v-card
          class="pa-4 mb-4"
          flat
        >
          <h1 class="mb-4">{{ $t('cart') }}</h1>

          <div class="divider" />

          <section class="delivery mt-4">
            <div class="subject">
              <span>{{ $t('delivery-address') }}:</span>
            </div>
            <div class="address mx-3 text-left">
              <span>{{ address }}</span>
            </div>
            <div class="actions">
              <v-btn
                color="primary"
                disabled
                text
                style="text-transform: none; letter-spacing: normal; padding: 0; height: fit-content; font-size: 14px; line-height: 20px;"
              >
                {{ $t('change') }}
              </v-btn>
            </div>
          </section>
        </v-card>

        <v-card
          class="pa-8"
          flat
        >
          <!-- <v-row>
            <v-col
              cols="12"
              class="d-flex justify-start align-center"
            >
              <v-checkbox
                v-model="all"
                label="Выбрать все"
                color="primary"
                class="ma-0 pa-0 mr-12"
                hide-details
              />

              <v-btn
                color="red"
                text
                style="text-transform: none; letter-spacing: normal; padding: 0; height: fit-content; font-size: 14px; line-height: 20px;"
              >
                Удалить выбранные
              </v-btn>
            </v-col>
          </v-row> -->
          <!-- <v-row
            style="background: #F5F5F5; border-radius: 4px;"
            class="mb-3"
          >
            <v-col
              cols="12"
              class="d-flex justify-space-between align-center"
            >
              <div class="seller">
                <span>{{ $t('seller') }}: </span>
                <NuxtLink
                  to="/"
                  style="text-decoration: none; font-size: 14px;"
                >
                  Cainiao Delivery-OD
                </NuxtLink>
              </div>
              <div class="seller-chat">
                <v-btn
                  color="primary"
                  disabled
                  text
                  style="text-transform: none; letter-spacing: normal; padding: 0; height: fit-content; font-size: 14px; line-height: 20px;"
                >
                  {{ $t('chat-with-seller') }}
                </v-btn>
              </div>
            </v-col>
          </v-row> -->
          <v-row
            v-for="item in products"
            :key="item.id"
            class="cart-item mt-2 mb-2"
          >
            <!-- <v-col
              cols="1"
              class="d-flex justify-center align-center"
            >
              <v-checkbox
                v-model="item.selected"
                color="primary"
                class="ma-0 pa-0"
                hide-details
              />
            </v-col> -->
            <v-col cols="2">
              <div
                class="item-image"
                :style="`background-image: url(${item.image.image.url})`"
                alt="PHOTO"
              />
            </v-col>
            <v-col
              cols="6"
              class="text-info"
            >
              <h3 class="mt-2">{{ getTitle(item) }}</h3>
              <v-btn
                color="red"
                class="mb-2"
                text
                style="text-transform: none; letter-spacing: normal; padding: 0; width: fit-content; height: fit-content; font-size: 14px; line-height: 20px;"
                @click="handleRemoveClick(item.id)"
              >
                {{ $t('remove') }}
              </v-btn>
            </v-col>
            <v-col cols="2">
              <money-format
                :value="getItemPrice(item) * item.amount"
                :locale="$i18n.locale"
                :currency-code="currency.code"
              />
            </v-col>
            <v-col cols="2">
              <v-text-field
                type="number"
                step="1"
                :label="$t('amount')"
                outlined
                dense
                min="0"
                ref="input"
                :rules="[numberRule]"
                v-model.number="item.amount"
                @input="handleProductAmountInput(item)"
              />
              <span
                style="font-size: 11px; line-height: 16px; color: #9E9E9E;"
              >
                <money-format
                  :value="getItemPrice(item)"
                  :locale="$i18n.locale"
                  :currency-code="currency.code"
                />
              </span>
            </v-col>
          </v-row>
          <v-row>
            <v-textarea
              v-model="comment"
              outlined
              :label="$t('comment')"
              class="mt-3"
              style="font-size: 14px; line-height: 20px; color: #616161;"
            />
          </v-row>
        </v-card>
      </v-col>
      <v-col cols="3">
        <v-card
          flat
          class="pa-7"
        >
          <v-card-text>
            <p
              class="mb-6 pa-0 text-center"
              style="font-size: 18px; line-height: 28px; color: #616161;"
            >
              {{ $t('total-price') }}:
            </p>
            <p
              class="text-center"
              style="font-weight: 600; font-size: 32px; line-height: 44px; color: #424242;"
            >
              <money-format
                :value="totalPrice"
                :locale="$i18n.locale"
                :currency-code="currency.code"
              />
            </p>
          </v-card-text>
          <v-card-actions>
            <v-btn
              color="headerOrange"
              depressed
              :disabled="!cartProducts?.length || !address || !totalPrice"
              style="letter-spacing: normal; width: 100%; color: #FFFFFF; font-weight: 700; font-size: 14px; line-height: 17px; padding: 20px;"
              @click="checkout"
            >
              {{ $t('checkout') }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>

    <v-dialog
      v-model="confirmRemoveDialog"
      persistent
      max-width="300"
    >
      <v-card>
        <v-card-title class="text-h5">
          {{ $t('confirmation') }}
        </v-card-title>
        <v-card-text>{{ $t('remove-item-cart-confirmation') }}</v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="red darken-1"
            text
            @click="removeProduct"
          >
            {{ $t('remove') }}
          </v-btn>
          <v-btn
            color="green darken-1"
            text
            @click="confirmRemoveDialog = false"
          >
            {{ $t('cancel') }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-bottom-sheet v-model="bottomSheet">
      <v-sheet
        class="text-center pa-6"
        height="200px"
      >
        <h2 class="py-4 mb-4">
          {{ $t('order-created-success') }}
        </h2>
        <NuxtLink
          to="/orders"
          style="text-decoration: none; font-size: 14px;"
        >
          <v-btn
            text
            class="mr-3"
          >
            {{ $t('view-orders') }}
          </v-btn>
        </NuxtLink>
        <NuxtLink
          to="/catalog?category=all"
          style="text-decoration: none; font-size: 14px;"
        >
          <v-btn
            text
            class="ml-3"
          >
            {{ $t('continue-shopping') }}
          </v-btn>
        </NuxtLink>
      </v-sheet>
    </v-bottom-sheet>
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import MoneyFormat from 'vue-money-format';

export default {
  name: 'CartPage',
  components: {
    'money-format': MoneyFormat,
  },
  data () {
    return {
      all: false,
      numberRule: val => {
        if (val < 0) return 'Please enter a positive number'
        return true
      },
      confirmRemoveDialog: false,
      productToRemoveId: '',
      comment: '',
      address: '',
      orderStatuses: [],
      bottomSheet: false,
      products: [],
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
    totalPrice () {
      let sum = 0;

      for (const item of this.products) {
        sum += this.getItemPrice(item) * item.amount;
      }

      return sum;
    },
  },
  watch: {
    user: function (newVal) {
      if (newVal?.id) {
        this.address = '';

        if (newVal.postcode) this.address += `${newVal.postcode}, `;
        if (newVal.country) this.address += `${newVal.country}, `;
        if (newVal.city) this.address += `${newVal.city}, `;
        if (newVal.street) this.address += `${newVal.street}, `;
        if (newVal.house) this.address += `${newVal.house}`;
        if (newVal.building) this.address += `${newVal.building}`;

        this.getCartProducts();
      }
    },
    cart: function (newVal) {
      console.log(898989, newVal.id);
      if (newVal.id) {
        this.getCartProducts();
      }
    },
    deep: true
  },
  async mounted () {
    await this.getOrderStatuses();

    this.checkCart();

    if (this.user?.id) {
      this.address = '';

      if (this.user.postcode) this.address += `${this.user.postcode}, `;
      if (this.user.country) this.address += `${this.user.country}, `;
      if (this.user.city) this.address += `${this.user.city}, `;
      if (this.user.street) this.address += `${this.user.street}, `;
      if (this.user.house) this.address += `${this.user.house}`;
      if (this.user.building) this.address += `${this.user.building}`;
    }
  },
  methods: {
    ...mapActions({
      removeProductFromCart: 'removeProductFromCart',
      setCartProductAmount: 'setCartProductAmount',
      clearCart: 'clearCart',
    }),
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
    checkCart () {
      if (this.cartProducts?.length) this.getCartProducts();
    },
    handleProductAmountInput(product) {
      console.log('** handleProductAmountInput');
      console.log(product);
      this.setCartProductAmount(product);
      this.updateCart();
    },
    handleRemoveClick (productId) {
      console.log('** handleRemoveClick');
      console.log(productId);

      this.productToRemoveId = productId;
      this.confirmRemoveDialog = true;
    },
    removeProduct () {
      console.log('** removeProduct');
      console.log(this.productToRemoveId);
      this.removeProductFromCart(this.productToRemoveId);
      this.confirmRemoveDialog = false;
      this.updateCart();
    },
    async getCartProducts () {
      let queryString = '';

      for (const p of this.cartProducts) {
        queryString += `{ id: { equals: "${p.id}" } }`;
      }

      console.log('queryString', queryString);
      console.log('cartProducts', this.cartProducts);

      if (!queryString) return;

      const graphqlQuery = {
        query: `
          query {
            products (where: { OR: [
              ${queryString}
            ] }) {
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

      console.log('Get products response', response);

      if (response?.data?.data?.products) {
        const products = response.data.data.products;

        for (const p of products) {
          const cartProduct = this.cartProducts.find(cartProduct => cartProduct.id === p.id);

          if (cartProduct) {
            p.amount = cartProduct.amount;
          }
        }

        this.products = [ ...products ];
      }
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
    async getOrderStatuses () {
      const graphqlQuery = {
        query: `
          query {
            orderStatuses {
              id
              code
              color
              titleRu
              titleEn
              titleCh
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get order statuses response', response);

      if (response?.data?.data?.orderStatuses) {
        this.orderStatuses = [...response.data.data.orderStatuses];
      }
    },
    async checkout () {
      console.log('** checkout');

      console.table(this.cartProducts);
      console.log(this.address);
      console.log(this.comment);
      console.table(this.orderStatuses);

      const orderStatusNew = this.orderStatuses.find(os => os.code === 'new');
      console.log(orderStatusNew);

      const graphqlQuery = {
        query: `
          mutation {
            createOrder (
              data: {
                products: "${JSON.stringify(this.cartProducts).replace(/"/g, '\'')}",
                user: {
                  connect: {
                    id: "${this.user.id}"
                  }
                }
                seller: {
                  connect: {
                    id: "${this.products[0].seller.id}"
                  }
                }
                status: {
                  connect: {
                    id: "${orderStatusNew.id}"
                  }
                }
                comment: "${this.comment}"
                address: "${this.address}"
              }
            ) {
              id
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Checkout response', response);

      if (response?.data?.data?.createOrder?.id) {
        this.clearCart();
        this.updateCart();
        this.createdOrderId = response.data.data.createOrder.id;
        this.bottomSheet = true;
      }
    },
    getItemPrice (item) {
      let price = 0;

      let intervals = item.intervals.replaceAll('*', '"');
      intervals = JSON.parse(intervals);

      for (const interval of intervals) {
        if (item.amount >= interval.from && item.amount <= interval.to) {
          price = interval.price;
        }
      }

      return price * parseFloat(this.currency.value);
    },
    minPrice (item) {
      if (!item.intervals) {
        return '';
      }

      let intervals = item.intervals.replaceAll('*', '"');
      intervals = JSON.parse(intervals);

      const usdPrice = intervals[intervals.length - 1].price;

      return usdPrice * parseFloat(this.currency.value);
    },
    maxPrice (item) {
      if (!item.intervals) {
        return '';
      }

      let intervals = item.intervals.replaceAll('*', '"');
      intervals = JSON.parse(intervals);

      const usdPrice = intervals[0].price;

      return usdPrice * parseFloat(this.currency.value);
    },
  }
}
</script>

<style>
  .v-label {
    font-size: 14px;
    line-height: 19px;
  }
</style>

<style lang="scss" scoped>
  .cart-page {

    h1 {
      font-weight: 600;
      font-size: 32px;
      line-height: 44px;
      color: #424242;

      sup {
        font-weight: 400;
        font-size: 16px;
        line-height: 22px;
      }
    }

    .divider {
      height: 1px;
      width: 100%;
      background-color: #E0E0E0;
    }

    .delivery {
      display: flex;
      flex-direction: row;
      justify-content: space-between;

      .subject {
        font-weight: 400;
        font-size: 14px;
        line-height: 20px;
        color: #757575;
      }

      .address {
        font-weight: 400;
        font-size: 14px;
        line-height: 20px;
        color: #424242;
        flex: 1;
      }

      .actions {
        display: flex;
        flex-direction: column;
      }
    }

    .seller {
      font-size: 14px;
      color: #757575;
    }

    .item-image {
      width: 100%;
      height: 100%;
      background-size: contain;
      background-repeat: no-repeat;
      background-position: center;
    }

    .cart-item {
      border-bottom: 1px solid #E0E0E0;

      h3 {
        font-weight: 400;
        font-size: 14px;
        line-height: 20px;
        color: #424242;
        padding-left: 4px;
      }

      .text-info {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
      }
    }
  }
</style>
