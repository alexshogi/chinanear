<template>
  <section>
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

    <v-row class="py-5">
      <v-data-table
        :headers="headers"
        :items="filteredOrders"
        :items-per-page="10"
        :loading="loading"
        flat
        style="width: 100%;"
      >
        <template
          v-slot:[`item.id`]="{ item }"
        >
          <NuxtLink
            :to="`/orders/${item.id}`"
          >
            {{ item.id }}
          </NuxtLink>
        </template>
        <template
          v-slot:[`item.createdAt`]="{ item }"
        >
          <span>{{ item.createdAt | datetime }}</span>
        </template>
        <template
          v-slot:[`item.confirmedAt`]="{ item }"
        >
          <span>{{ item.confirmedAt | datetime }}</span>
        </template>
        <template
          v-slot:[`item.paidAt`]="{ item }"
        >
          <span>{{ item.paidAt | datetime }}</span>
        </template>
        <template
          v-slot:[`item.status`]="{ item }"
        >
          <Label
            :value="$i18n.locale === 'ru' ? item.status.titleRu : item.status.titleEn"
            :color="item.status.color"
          />
        </template>
        <template
          v-slot:[`item.goodsAmount`]="{ item }"
        >
          <span>{{ calculateOrderGoods(item) }}</span>
        </template>
        <template
          v-slot:[`item.positionsAmount`]="{ item }"
        >
          <span>{{ calculateOrderPositions(item) }}</span>
        </template>
        <template
          v-slot:[`item.sum`]="{ item }"
        >
          <money-format
            :value="calculateOrderSum(item)"
            :locale="$i18n.locale"
            :currency-code="currency.code"
          />
        </template>
        <template
          v-slot:[`item.seller`]="{ item }"
        >
          <span>{{ $i18n.locale === 'ru' ? item.seller.companyMarketNameRu : item.seller.companyMarketNameEn }}</span>
        </template>
      </v-data-table>
    </v-row>
  </section>
</template>

<script>
import { mapGetters } from 'vuex';
import Label from '@/components/Label.vue';
import MoneyFormat from 'vue-money-format';

export default {
  name: 'OrdersAllPage',
  components: {
    Label,
    'money-format': MoneyFormat,
  },
  data() {
    return {
      loading: false,
      searchValue: '',
      orders: [],
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
        { text: this.$t('order'), value: 'id' },
        { text: this.$t('status'), value: 'status', sortable: false },
        { text: this.$t('created'), value: 'createdAt', sortable: false },
        { text: this.$t('confirmed'), value: 'confirmedAt', sortable: false },
        { text: this.$t('paid'), value: 'paidAt', sortable: false },
        { text: this.$t('positions-amount'), value: 'positionsAmount', sortable: false },
        { text: this.$t('goods-amount'), value: 'goodsAmount', sortable: false },
        { text: this.$t('seller'), value: 'seller', sortable: false },
        { text: this.$t('order-sum'), value: 'sum', sortable: false },
      ]
    },
    filteredOrders () {
      if (this.searchValue) {
        return this.orders.filter(p => p.id.toLowerCase().includes(this.searchValue.toLowerCase()));
      }

      return this.orders;
    },
  },
  watch: {
    user () {
      this.getOrders();
    }
  },
  mounted () {
    this.getOrders();
  },
  methods: {
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
    calculateOrderPositions (order) {
      return order.products?.length || '?';
    },
    calculateOrderGoods (order) {
      let counter = 0;

      for (const product of order.products) {
        counter = counter + product.amount;
      }

      return counter || '?';
    },
    calculateOrderSum (order) {
      let sum = 0;

      for (const item of order.products) {
        sum += this.getItemPrice(item) * item.amount;
      }

      return sum || '?';
    },
    async getOrderProducts (orderProducts) {
      let queryString = '';

      for (const p of orderProducts) {
        queryString += `{ id: { equals: "${p.id}" } }`;
      }

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
          const orderProduct = orderProducts.find(orderProduct => orderProduct.id === p.id);

          if (orderProduct) {
            p.amount = orderProduct.amount;
          }
        }

        return products;
      }
    },
    async getOrders () {
      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            orders {
              id
              products
              seller {
                name
                surname
                companyName
                companyMarketNameRu
                companyMarketNameEn
              }
              status {
                code
                color
                titleRu
                titleEn
                titleCh
              }
              address
              comment
              createdAt
              updatedAt
              confirmedAt
              paidAt
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get all orders response', response);

      const orders = response?.data?.data?.orders;

      if (orders) {
        for (const o of orders) {
          if (o.products) {
            o.products = JSON.parse(o.products.replace(/'/g, '"'));
            o.products = await this.getOrderProducts(o.products);
          }
        }

        this.orders = orders;
      }

      this.loading = false;
    }
  }
}
</script>
