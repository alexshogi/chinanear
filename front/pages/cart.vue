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
            v-for="item in cartProducts"
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
                :style="`background-image: url(${item.image.url})`"
                alt="PHOTO"
              />
            </v-col>
            <v-col
              cols="6"
              class="text-info"
            >
              <h3 class="mt-2">{{ item.title }}</h3>
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
              <p class="mt-2">{{ item.intervals[0]?.price * item.amount }} ₽ </p>
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
                {{ item.intervals[0]?.price }}
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
                locale="ru"
                currency-code="rub"
              />
            </p>
          </v-card-text>
          <v-card-actions>
            <v-btn
              color="headerOrange"
              depressed
              style="letter-spacing: normal; width: 100%; color: #FFFFFF; font-weight: 700; font-size: 14px; line-height: 17px; padding: 20px;"
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
          Confirmation
        </v-card-title>
        <v-card-text>Are you sure you want to remove this item from your cart?</v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="red darken-1"
            text
            @click="removeProduct"
          >
            Remove
          </v-btn>
          <v-btn
            color="green darken-1"
            text
            @click="confirmRemoveDialog = false"
          >
            Cancel
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
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
    }
  },
  computed: {
    ...mapGetters({
      cartProducts: 'cartProducts',
      user: 'user',
      cart: 'cart',
    }),
    totalPrice () {
      let price = 0;

      for (const item of this.cartProducts) {
        if (item?.intervals?.length) {
          price += item.intervals[0].price * item.amount;
        }
      }

      return price;
    }
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
      }
    },
  },
  mounted () {},
  methods: {
    ...mapActions({
      // addProductToCart: 'addProductToCart',
      removeProductFromCart: 'removeProductFromCart',
      setCartProductAmount: 'setCartProductAmount',
    }),
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

      .item-image {
        width: 100px;
        height: 100px;
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
        // border: 1px solid #EEEEEE;
        border-radius: 4px;
      }
    }
  }
</style>
