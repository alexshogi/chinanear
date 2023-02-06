<template>
  <v-container
    ref="page"
    class="order-page"
    style="margin-top: 52px;"
  >
    <v-row>
      <v-col>
        <v-card
          flat
          class="pa-4"
        >
          <div
            class="d-flex justify-start align-center mb-4"
          >
            <h1 class="mr-8">Заказ № {{ orderId }}</h1>
            <Label class="mr-8" value="Готов к отгрузке" />
            <v-btn
              color="red"
              text
              style="text-transform: none; letter-spacing: normal; padding: 0; width: fit-content; height: fit-content; font-size: 14px; line-height: 20px;"
            >
              Отменить заказ
            </v-btn>
          </div>

          <div class="divider" />

          <v-row
            class="mt-2"
            style="font-size: 16px;"
          >
            <v-col
              cols="1"
              style="color: #9E9E9E;"
            >
              Продавец:
            </v-col>
            <v-col cols="11">
              <NuxtLink
                to="/"
                style="text-decoration: none;"
              >
                Cainiao Delivery-OD
              </NuxtLink>
            </v-col>
          </v-row>

          <v-row
            class="mt-2 mb-2"
            style="font-size: 16px;"
          >
            <v-col
              cols="1"
              style="color: #9E9E9E;"
            >
              Доставка:
            </v-col>
            <v-col cols="11">
              141282, Россия, Московская область, городской округ Пушкинский, Ивантеевка, Пионерская ул. 11
            </v-col>
          </v-row>

          <div class="divider" />

          <v-row
            v-for="item in items"
            :key="item.id"
            class="order-item mt-2 mb-2"
          >
            <v-col cols="1">
              <div
                class="item-image"
                :style="`background-image: url(${item.photo})`"
                alt="PHOTO"
              />
            </v-col>
            <v-col
              cols="5"
              class="text-info"
            >
              {{ item.title }}
            </v-col>
            <v-col
              cols="2"
              class="text-info"
            >
              Стоимость: {{ item.price }} ₽
            </v-col>
            <v-col
              cols="2"
              class="text-info text-center"
            >
              Количество: {{ item.amount }} шт.
            </v-col>
            <v-col
              cols="2"
              class="text-info text-right pr-10"
            >
              {{ item.amount * item.price }} ₽
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
              class="text-right pr-10"
            >
              <h2>
                Стоимость заказа: {{ totalPrice }} ₽
              </h2>
            </v-col>
          </v-row>

          <v-row>
            <v-col cols="12">
              <v-textarea
                v-model="comment"
                outlined
                label="Комментарий к заказу"
                class="mt-3"
                style="font-size: 14px; line-height: 20px; color: #616161;"
              />
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import Label from '@/components/Label.vue'

export default {
  name: 'OrderPage',
  components: {
    Label,
  },
  data () {
    return {
      orderId: '',
      comment: '',
      items: [
        {
          photo: 'https://coffe-mashina.ru/image/cache/catalog/products/Philips/philips_ep1220_00_series_1200-767x767.jpg',
          title: 'Автоматическая кофемашина Philips 1220 series',
          price: 33800,
          amount: 50,
          labels: [],
          id: '12qw',
          selected: false,
        },
        {
          photo: 'https://cdn.vseinstrumenti.ru/images/goods/stroitelnyj-instrument/generatory/1064774/560x504/53120475.jpg',
          title: 'Бензиновый генератор DENZEL PS 80 E-3',
          price: 57520,
          amount: 50,
          labels: '',
          id: '34as',
          selected: true,
        },
        {
          photo: 'https://avtodeti.ru/f/tovar/avtokreslo/recaro/monza-nova-2-seatfix/select-teal-green/avtokreslo-recaro-monza-nova-2-seatfix-select-teal-green_l.jpg',
          title: 'Recaro Monza Nova 2 Seatfix',
          price: 32999,
          amount: 10,
          labels: '',
          id: '56zx',
          selected: false,
        }
      ]
    }
  },
  computed: {
    totalPrice () {
      let price = 0;

      for (const item of this.items) {
        price += item.price * item.amount;
      }

      return price;
    }
  },
  created () {
    console.log('**')

    const orderId = this.$route.params.order

    console.log('orderId', orderId)

    this.orderId = orderId
  },
}
</script>

<style lang="scss" scoped>
  .order-page {

    h1 {
      font-weight: 600;
      font-size: 32px;
      line-height: 44px;
      color: #424242;
    }

    .divider {
      height: 1px;
      width: 100%;
      background-color: #E0E0E0;
    }

    .order-item {
      border-bottom: 1px solid #E0E0E0;

      .text-info {
        font-weight: 400;
        font-size: 14px;
        line-height: 20px;
        color: #424242;
        padding: 8px;
        padding-top: 16px;
      }

      .item-image {
        width: 100px;
        height: 100px;
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
        border: 1px solid #EEEEEE;
        border-radius: 4px;
      }
    }
  }
</style>
