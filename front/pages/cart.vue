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
          <h1 class="mb-4">
            Корзина
            <!-- <sup>(3)</sup> -->
          </h1>

          <div class="divider" />

          <section class="delivery mt-4">
            <div class="subject">
              <span>Доставка:</span>
            </div>
            <div class="address mx-3 text-left">
              <span>141282, Россия, Московская область, городской округ Пушкинский, Ивантеевка, Пионерская ул. 11</span>
            </div>
            <div class="actions">
              <v-btn
                color="primary"
                text
                style="text-transform: none; letter-spacing: normal; padding: 0; height: fit-content; font-size: 14px; line-height: 20px;"
              >
                Изменить
              </v-btn>
            </div>
          </section>
        </v-card>

        <v-card
          class="pa-8"
          flat
        >
          <v-row>
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
          </v-row>
          <v-row
            style="background: #F5F5F5; border-radius: 4px;"
            class="mb-3"
          >
            <v-col
              cols="12"
              class="d-flex justify-space-between align-center"
            >
              <div class="seller">
                <span>Продавец: </span>
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
                  text
                  style="text-transform: none; letter-spacing: normal; padding: 0; height: fit-content; font-size: 14px; line-height: 20px;"
                >
                  Чат с продавцом
                </v-btn>
              </div>
            </v-col>
          </v-row>
          <v-row
            v-for="item in cartProducts"
            :key="item.id"
            class="cart-item mt-2 mb-2"
          >
            <v-col
              cols="1"
              class="d-flex justify-center align-center"
            >
              <v-checkbox
                v-model="item.selected"
                color="primary"
                class="ma-0 pa-0"
                hide-details
              />
            </v-col>
            <v-col cols="2">
              <div
                class="item-image"
                :style="`background-image: url(${item.image?.url})`"
                alt="PHOTO"
              />
            </v-col>
            <v-col
              cols="5"
              class="text-info"
            >
              <h3 class="mt-2">{{ item.title }}</h3>
              <v-btn
                color="red"
                class="mb-2"
                text
                style="text-transform: none; letter-spacing: normal; padding: 0; width: fit-content; height: fit-content; font-size: 14px; line-height: 20px;"
              >
                Удалить
              </v-btn>
            </v-col>
            <v-col cols="2">
              <p class="mt-2">{{ item.intervals[0]?.price * item.amount }} ₽ </p>
            </v-col>
            <v-col cols="2">
              <v-text-field
                type="number"   
                step="1"
                label="Количество, шт"
                outlined
                dense
                min="0"
                ref="input"
                :rules="[numberRule]"
                v-model.number="item.amount"
              />
              <span
                style="font-size: 11px; line-height: 16px; color: #9E9E9E;"
              >
                {{ item.intervals[0]?.price }} ₽ / шт.
              </span>
            </v-col>
          </v-row>
          <v-row>
            <v-textarea
              v-model="comment"
              outlined
              label="Комментарий к заказу"
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
              Общая стоимость:
            </p>
            <p
              class="text-center"
              style="font-weight: 600; font-size: 32px; line-height: 44px; color: #424242;"
            >
              {{ totalPrice }}
              <span style="font-size: 26px;">₽</span>
            </p>
          </v-card-text>
          <v-card-actions>
            <v-btn
              color="headerOrange"
              depressed
              style="letter-spacing: normal; width: 100%; color: #FFFFFF; font-weight: 700; font-size: 14px; line-height: 17px; padding: 20px;"
            >
              Оформить
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';

export default {
  name: 'CartPage',
  data () {
    return {
      all: false,
      numberRule: val => {
        if (val < 0) return 'Please enter a positive number'
        return true
      },
      comment: '',
      items: [
        {
          photo: 'https://coffe-mashina.ru/image/cache/catalog/products/Philips/philips_ep1220_00_series_1200-767x767.jpg',
          title: 'Автоматическая кофемашина Philips 1220 series',
          price: 33800,
          amount: 2,
          labels: [],
          id: '12qw',
          selected: false,
        },
        {
          photo: 'https://cdn.vseinstrumenti.ru/images/goods/stroitelnyj-instrument/generatory/1064774/560x504/53120475.jpg',
          title: 'Бензиновый генератор DENZEL PS 80 E-3',
          price: 57520,
          amount: 1,
          labels: '',
          id: '34as',
          selected: true,
        },
        {
          photo: 'https://avtodeti.ru/f/tovar/avtokreslo/recaro/monza-nova-2-seatfix/select-teal-green/avtokreslo-recaro-monza-nova-2-seatfix-select-teal-green_l.jpg',
          title: 'Recaro Monza Nova 2 Seatfix',
          price: 32999,
          amount: 1,
          labels: '',
          id: '56zx',
          selected: false,
        }
      ]
    }
  },
  computed: {
    ...mapGetters({
      cartProducts: 'cartProducts',
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
  mounted () {
    console.log(this.cartProducts);
  },
  methods: {
    ...mapActions({
      // addProductToCart: 'addProductToCart',
    }),
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
