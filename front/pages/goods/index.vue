<template>
  <v-container
    ref="page"
    class="goods-page"
    style="margin-top: 52px;"
  >
    <v-row>
      <v-col>
        <v-card
          flat
          class="pa-4"
        >
          <div class="d-flex justify-space-between align-center pb-4">
            <h1>Мои товары</h1>
            <v-btn
              color="primary"
              depressed
              style="letter-spacing: normal; width: 100%; color: #FFFFFF; font-weight: 600; font-size: 14px; line-height: 17px; padding: 20px; width: fit-content"
              @click="goToAdd"
            >
              Добавить товар
            </v-btn>
          </div>

          <div class="divider" />

          <v-row class="mt-4">
            <v-col cols="4">
              <v-text-field
                dense
                outlined
                height="38"
                hide-details
                placeholder="Поиск"
                append-icon="mdi-magnify"
              />
            </v-col>
          </v-row>

          <v-row class="filters-row px-3 py-7">
            <div>
              <span>Показать</span>
            </div>
            
            <div>
              <v-select
                :items="statuses"
                dense
                height="38"
                hide-details
                outlined
                style="max-width: 150px; font-size: 14px;"
              />
            </div>

            <div>
              <span>Категория 1:</span>
            </div>

            <div>
              <v-select
                :items="cats1"
                dense
                height="38"
                hide-details
                outlined
                style="max-width: 180px; font-size: 14px;"
              />
            </div>

            <div>
              <span>Категория 2:</span>
            </div>

            <div>
              <v-select
                :items="cats2"
                dense
                height="38"
                hide-details
                outlined
                style="max-width: 180px; font-size: 14px;"
              />
            </div>

            <div>
              <span>Категория 3:</span>
            </div>

            <div>
              <v-select
                :items="cats3"
                dense
                height="38"
                hide-details
                outlined
                style="max-width: 180px; font-size: 14px;"
              />
            </div>

            <div>
              <v-btn
                color="primary"
                depressed
                style="text-transform: none; letter-spacing: normal;"
              >
                Применить
              </v-btn>
            </div>

            <div>
              <v-btn
                color="primary"
                text
                style="text-transform: none; letter-spacing: normal; padding: 0; height: fit-content; font-size: 14px; line-height: 20px;"
              >
                Сбросить фильтры
              </v-btn>
            </div>
          </v-row>

          <v-row class="py-5">
            <v-data-table
              v-model="selected"
              :headers="headers"
              :items="items"
              :items-per-page="15"
              checkbox-color="primary"
              flat
              show-select
              style="width: 100%;"
            />
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: 'GoodsPage',
  data () {
    return {
      itemsPart: [
        {
          photo: 'https://coffe-mashina.ru/image/cache/catalog/products/Philips/philips_ep1220_00_series_1200-767x767.jpg',
          title: 'Автоматическая кофемашина Philips 1220 series',
          category1: 'Техника для кухни',
          price: 33800,
          balance: 217,
          isActive: true,
          lastActionDate: '11.01.2023'
        },
        {
          photo: 'https://cdn.vseinstrumenti.ru/images/goods/stroitelnyj-instrument/generatory/1064774/560x504/53120475.jpg',
          title: 'Бензиновый генератор DENZEL PS 80 E-3',
          category1: 'Бензиновые генераторы',
          price: 57520,
          balance: 16,
          isActive: false,
          lastActionDate: '12.01.2023'
        },
        {
          photo: 'https://avtodeti.ru/f/tovar/avtokreslo/recaro/monza-nova-2-seatfix/select-teal-green/avtokreslo-recaro-monza-nova-2-seatfix-select-teal-green_l.jpg',
          title: 'Recaro Monza Nova 2 Seatfix',
          category1: 'Автокресла',
          price: 32999,
          balance: 179,
          isActive: true,
          lastActionDate: '13.01.2023'
        },
      ],
      headers: [
        { text: 'Товар', value: 'title' },
        { text: 'Остаток', value: 'balance' },
        { text: 'Категория', value: 'category1' },
        { text: 'Создан/изменен', value: 'lastActionDate' },
        { text: 'Активность', value: 'isActive' },
        { text: 'Мин. стоимость', value: 'price' }
      ],
      items: [],
      statuses: [
        'Все',
        'Активные',
        'Неактивные'
      ],
      cats1: [
        'Example 1',
        'Example 2',
        'Example 3',
        'Example 4',
        'Example 5',
        'Example 6',
      ],
      cats2: [
        'Example 1',
        'Example 2',
        'Example 3',
        'Example 4',
        'Example 5',
        'Example 6',
      ],
      cats3: [
        'Example 1',
        'Example 2',
        'Example 3',
        'Example 4',
        'Example 5',
        'Example 6',
      ],
      selected: [],
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
    let id1 = 1;
    let id2 = 1000;
    let id3 = 2000;

    for (let i = 0; i < 100; i++) {
      let item1 = JSON.parse(JSON.stringify(this.itemsPart[0]));
      id1 += 1;
      item1.id = id1;
      this.items.push(item1);

      let item2 = JSON.parse(JSON.stringify(this.itemsPart[1]));
      id2 += 1;
      item2.id = id2;
      this.items.push(item2);

      let item3 = JSON.parse(JSON.stringify(this.itemsPart[2]));
      id3 += 1;
      item3.id = id3;
      this.items.push(item3);
    }
  },
  methods: {
    goToAdd () {
      this.$router.push({ path: 'goods/add' });
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
  .goods-page {

    .divider {
      height: 1px;
      width: 100%;
      background-color: #E0E0E0;
    }

    h1 {
      font-weight: 600;
      font-size: 32px;
      line-height: 44px;
      color: #424242;
    }

    .filters-row {
      display: flex;
      flex-direction: row;
      justify-content: space-between;
      align-items: center;
      color: #616161;
      font-size: 14px;
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
        border: 1px solid #EEEEEE;
        border-radius: 4px;
      }
    }
  }
</style>
