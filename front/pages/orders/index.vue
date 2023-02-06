<template>
  <v-container
    ref="page"
    class="orders-page"
    style="margin-top: 52px;"
  >
    <v-row>
      <v-col>
        <v-card
          flat
          class="pa-4"
        >
          <h1 class="mb-4">Мои заказы</h1>

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
              />
            </div>

            <div>
              <span>За период с:</span>
            </div>
            
            <div>
              <v-menu
                ref="dateFromMenu"
                v-model="dateFromMenu"
                :close-on-content-click="false"
                :return-value.sync="dateFrom"
                transition="scale-transition"
                offset-y
                min-width="auto"
              >
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field
                    v-model="dateFrom"
                    prepend-icon="mdi-calendar"
                    outlined
                    hide-details
                    dense
                    readonly
                    v-bind="attrs"
                    v-on="on"
                  ></v-text-field>
                </template>
                <v-date-picker
                  v-model="dateFrom"
                  no-title
                  scrollable
                >
                  <v-spacer></v-spacer>
                  <v-btn
                    text
                    color="primary"
                    @click="dateFromMenu = false"
                  >
                    Cancel
                  </v-btn>
                  <v-btn
                    text
                    color="primary"
                    @click="$refs.dateFromMenu.save(dateFrom)"
                  >
                    OK
                  </v-btn>
                </v-date-picker>
              </v-menu>
            </div>
            
            <div>
              <span>по:</span>
            </div>
            
            <div>
              <v-menu
                ref="dateToMenu"
                v-model="dateToMenu"
                :close-on-content-click="false"
                :return-value.sync="dateTo"
                transition="scale-transition"
                offset-y
                min-width="auto"
              >
                <template v-slot:activator="{ on, attrs }">
                  <v-text-field
                    v-model="dateTo"
                    prepend-icon="mdi-calendar"
                    outlined
                    hide-details
                    dense
                    readonly
                    v-bind="attrs"
                    v-on="on"
                  ></v-text-field>
                </template>
                <v-date-picker
                  v-model="dateTo"
                  no-title
                  scrollable
                >
                  <v-spacer></v-spacer>
                  <v-btn
                    text
                    color="primary"
                    @click="dateToMenu = false"
                  >
                    Cancel
                  </v-btn>
                  <v-btn
                    text
                    color="primary"
                    @click="$refs.dateToMenu.save(dateTo)"
                  >
                    OK
                  </v-btn>
                </v-date-picker>
              </v-menu>
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
              :headers="headers"
              :items="orders"
              :items-per-page="10"
              @click:row="handleClickRow"
              flat
            />
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: 'OrderPage',
  data() {
    return {
      statuses: [
        'Foo',
        'Bar',
        'Fizz',
        'Buzz'
      ],
      dateFrom: (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10),
      dateTo: (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10),
      dateFromMenu: false,
      dateToMenu: false,
      headers: [
        { text: 'Заказ', value: 'id' },
        { text: 'Статус', value: 'status' },
        { text: 'Создан', value: 'dateCreate' },
        { text: 'Подтвержден', value: 'dateConfirm' },
        { text: 'Оплачен', value: 'datePay' },
        { text: 'Наименований', value: 'positionsAmount' },
        { text: 'Товаров', value: 'goodsAmount' },
        { text: 'Продавец', value: 'seller' },
        { text: 'Сумма заказа', value: 'sum' },
      ],
      orders: [
        {
          id: 'XM8S2459WML-0000',
          status: 'Готов к отгрузке',
          dateCreate: '09.08.2022 10:27',
          dateConfirm: '10.08.2022 10:27',
          datePay: '11.08.2022 10:27',
          positionsAmount: 7,
          goodsAmount: 985,
          seller: 'Cainiao Delivery-OD',
          sum: 1100500
        },
      ]
    }
  },
  beforeMount () {
    for (let i = 0; i < 400; i++) {
      let item = JSON.parse(JSON.stringify(this.orders[0]));
      item.id += i;
      this.orders.push(item);
    }
  },
  methods: {
    handleClickRow (v) {
      this.$router.push({ path: `orders/${v.id}` });
    }
  }
}
</script>

<style lang="scss" scoped>
  .orders-page {

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

    .filters-row {
      display: flex;
      flex-direction: row;
      justify-content: space-between;
      align-items: center;
      color: #616161;
      font-size: 14px;
    }
  }
</style>
