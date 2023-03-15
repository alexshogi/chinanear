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
              :loading="loading"
              checkbox-color="primary"
              flat
              style="width: 100%;"
            >
              <template
                v-slot:[`item.image`]="{ item }"
              >
                <div
                  class="item-image"
                  :style="`background-image: url(${item.image?.image?.url})`"
                  alt="PHOTO"
                />
              </template>
              <template
                v-slot:[`item.title`]="{ item }"
              >
                <span>{{ getTitle(item) }}</span>
              </template>
              <template
                v-slot:[`item.category`]="{ item }"
              >
                <span>{{ getCategoryTitle(item) }}</span>
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
                  :value="minPrice(item)"
                  :locale="$i18n.locale"
                  :currency-code="currency.code"
                />
              </template>
              <template
                #[`item.actions`]="{ item }"
              >
                <v-btn
                  icon
                  color="primary"
                  @click="toggleItemActivity(item)"
                >
                  <v-icon v-if="!item.isActive">mdi-play</v-icon>
                  <v-icon v-if="item.isActive">mdi-pause</v-icon>
                </v-btn>
                <v-btn
                  icon
                  color="primary"
                  @click="goToEdit(item)"
                >
                  <v-icon>mdi-pencil</v-icon>
                </v-btn>
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
      loading: false,
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
      user: 'user',
      currency: 'currency',
      currencyRates: 'currencyRates',
    }),
    headers () {
      return [
        { text: '', value: 'image', width: 80 },
        { text: this.$t('product'), value: 'title' },
        { text: this.$t('balance'), value: 'balance' },
        { text: this.$t('category'), value: 'category' },
        { text: this.$t('created-changed'), value: 'createdAt' },
        { text: this.$t('activity'), value: 'isActive' },
        { text: this.$t('min-price'), value: 'minPrice' },
        { text: '', value: 'actions', sortable: false },
      ]
    },
    filteredProducts () {
      if (this.searchValue) {
        return this.products.filter(p => p.titleEn.toLowerCase().includes(this.searchValue.toLowerCase()));
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
    goToEdit (item) {
      console.log('=> goToEdit', item.id);
      this.$router.push({ path: `/goods/edit/${item.id}` });
    },
    async toggleItemActivity (item) {
      console.log('=> toggleItemActivity');
      console.log(item.id, item.isActive);

      const graphqlQuery = {
        query: `
          mutation {
            updateProduct(
              where: {
                id: "${item.id}"
              }
              data: {
                isActive: ${!item.isActive}
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

      console.log('Create room response', response);

      const productUpdated = response?.data?.data?.updateProduct;

      const product = this.products.find((p) => p.id === productUpdated.id);

      product.isActive = !item.isActive;
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
    getCategoryTitle (item) {
      if (this.$i18n.locale === 'ru') return item.category?.titleRu;
      if (this.$i18n.locale === 'en') return item.category?.titleEn;
      if (this.$i18n.locale === 'ch') return item.category?.titleCh;
    },
    goToAdd () {
      this.$router.push({ path: 'goods/add' });
    },
    async getProducts () {
      this.loading = true;

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

      const products = response?.data?.data?.products;

      this.loading = false;

      if (products && products.length) {
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
