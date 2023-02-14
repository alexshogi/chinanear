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
            <h1>{{ $t('my-goods') }}</h1>
            <v-btn
              color="primary"
              depressed
              style="letter-spacing: normal; width: 100%; color: #FFFFFF; font-weight: 600; font-size: 14px; line-height: 17px; padding: 20px; width: fit-content"
              @click="goToAdd"
            >
              {{ $t('create-product') }}
            </v-btn>
          </div>

          <div class="divider" />

          <v-row class="mt-4">
            <v-col cols="4">
              <v-text-field
                v-model="searchValue"
                clearable
                dense
                outlined
                height="38"
                hide-details
                :placeholder="$t('search')"
                append-icon="mdi-magnify"
              />
            </v-col>
          </v-row>

          <!-- <v-row class="filters-row px-3 py-7">
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
          </v-row> -->

          <v-row class="py-5">
            <v-data-table
              :headers="headers"
              :items="filteredProducts"
              :items-per-page="15"
              :loading="!products.length"
              checkbox-color="primary"
              flat
              style="width: 100%;"
            >
              <template
                v-slot:[`item.image`]="{ item }"
              >
                <div
                  class="item-image"
                  :style="`background-image: url(${item.image?.url})`"
                  alt="PHOTO"
                />
              </template>
              <template
                v-slot:[`item.createdAt`]="{ item }"
              >
                <span>{{ item.createdAt | datetime }}</span>
              </template>
              <template
                v-slot:[`item.isActive`]="{ item }"
              >
                <Label
                  :value="item.isActive ? $t('active') : $t('inactive')"
                  :color="item.isActive ? 'green' : 'grey'"
                />
              </template>
              <template
                v-slot:[`item.minPrice`]="{ item }"
              >
                <money-format
                  :value="item.minPrice"
                  locale="ru"
                  currency-code="rub"
                />
              </template>
            </v-data-table>
          </v-row>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import MoneyFormat from 'vue-money-format';
import Label from '@/components/Label.vue';

export default {
  name: 'GoodsPage',
  components: {
    Label,
    'money-format': MoneyFormat,
  },
  data () {
    return {
      products: [],
      searchValue: '',
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
    ...mapGetters({
      user: 'user'
    }),
    headers () {
      return [
        { text: '', value: 'image', width: 80 },
        { text: this.$t('product'), value: 'title' },
        { text: this.$t('balance'), value: 'balance' },
        { text: this.$t('category'), value: 'category1' },
        { text: this.$t('created-changed'), value: 'createdAt' },
        { text: this.$t('activity'), value: 'isActive' },
        { text: this.$t('min-price'), value: 'minPrice' }
      ]
    },
    filteredProducts () {
      if (this.searchValue) {
        return this.products.filter(p => p.title.toLowerCase().includes(this.searchValue.toLowerCase()));
      }

      return this.products;
    }
  },
  async mounted () {
    const auth = localStorage.getItem('auth');

    if (auth) {
      await this.setAuth(JSON.parse(auth));
    }

    this.getProducts();
  },
  methods: {
    ...mapActions({
      setAuth: 'login',
    }),
    goToAdd () {
      this.$router.push({ path: 'goods/add' });
    },
    minPrice (item) {
      if (! item.intervals) {
        return '';
      }

      return item.intervals[item.intervals.length - 1].price;
    },
    maxPrice (item) {
      if (! item.intervals) {
        return '';
      }

      return item.intervals[0].price;
    },
    async getProducts () {
      const graphqlQuery = {
        query: `
          query {
            products (
              where: {
                seller: {
                  id: {
                    equals: "${this.user.id}"
                  }
                }
              }
            ) {
              id
              title
              caption
              description {
                document
              }
              balance
              image {
                url
              }
              isActive
              intervals
              createdAt
              category1
              category2
              category3
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get products response', response);

      const products = response?.data?.data?.products;

      if (products) {
        for (const p of products) {
          p.minPrice = this.minPrice(p);
        }

        this.products = [ ...products ];
      } else {
        // TODO: Show error popup
      }
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
    }

    .item-image {
      width: 60px;
      height: 60px;
      background-size: contain;
      background-repeat: no-repeat;
      background-position: center;
    }
  }
</style>
