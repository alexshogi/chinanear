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
            <h1
              class="mr-8"
              @click="copyOrderIdToClipboard"
            >
              {{ $t('order') }}
              №
              {{ order.id }}
            </h1>
            <Label
              v-if="order.status"
              class="mr-8"
              :value="$i18n.locale === 'ru' ? order.status.titleRu : order.status.titleEn"
              :color="order.status?.color"
            />
            <v-btn
              v-if="order.status?.code !== 'canceled'"
              color="red"
              text
              style="text-transform: none; letter-spacing: normal; padding: 4px 8px; width: fit-content; height: fit-content; font-size: 14px; line-height: 20px;"
              @click="confirmCancelOrder = true"
            >
              {{ $t('cancel-order') }}
            </v-btn>
          </div>

          <div class="divider" />

          <v-row
            class="mt-2"
            style="font-size: 16px;"
          >
            <v-col
              cols="2"
              style="color: #9E9E9E;"
            >
              {{ $t('seller') }}:
            </v-col>
            <v-col cols="10">
              <NuxtLink
                :to="`/chat?seller=${order.seller?.id}`"
                style="text-decoration: none;"
              >
                {{ $i18n.locale === 'ru' ? order.seller?.companyMarketNameRu : order.seller?.companyMarketNameEn }}
              </NuxtLink>
            </v-col>
          </v-row>

          <v-row
            class="mt-2 mb-2"
            style="font-size: 16px;"
          >
            <v-col
              cols="2"
              style="color: #9E9E9E;"
            >
              {{ $t('delivery-address') }}:
            </v-col>
            <v-col cols="10">
              {{ order.address }}
            </v-col>
          </v-row>

          <div class="divider" />

          <section
            class="order-products"
          >
            <v-data-table
              :headers="headers"
              :items="order.products"
              :items-per-page="10"
              :loading="loading"
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
                v-slot:[`item.price`]="{ item }"
              >
                <money-format
                  :value="getItemPrice(item)"
                  :locale="$i18n.locale"
                  :currency-code="currency.code"
                />
              </template>
              <template
                v-slot:[`item.sum`]="{ item }"
              >
                <money-format
                  :value="getItemPrice(item) * item.amount"
                  :locale="$i18n.locale"
                  :currency-code="currency.code"
                />
              </template>
            </v-data-table>
            <!-- <v-row
              v-for="item in order.products"
              :key="item.id"
              class="order-item mt-2 mb-2"
            >
              <v-col cols="1">
                <div
                  v-if="item.photo"
                  class="item-image"
                  :style="`background-image: url(${item.photo.url})`"
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
            </v-row> -->
          </section>

          <v-row>
            <v-col
              cols="12"
              class="text-right pr-10 pt-10"
            >
              <h2>
                {{ $t('order-sum') }}:
                <money-format
                  :value="orderSum"
                  :locale="$i18n.locale"
                  :currency-code="currency.code"
                  style="display: inline-block;"
                />
              </h2>
            </v-col>
          </v-row>

          <v-row>
            <v-col cols="12">
              <h4 class="mb-3">{{ $t('order-comment') }}</h4>
              <p style="font-size: 14px; line-height: 20px; color: #616161;">
                {{ order.comment }}
              </p>
            </v-col>
          </v-row>
        </v-card>
      </v-col>
    </v-row>

    <v-dialog
      v-model="confirmCancelOrder"
      persistent
      max-width="300"
    >
      <v-card>
        <v-card-title class="text-h5">
          {{ $t('confirmation') }}
        </v-card-title>
        <v-card-text>{{ $t('cancel-order-confirmation') }}</v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn
            color="red darken-1"
            text
            @click="cancelOrder"
          >
            {{ $t('yes') }}
          </v-btn>
          <v-btn
            color="green darken-1"
            text
            @click="confirmCancelOrder = false"
          >
            {{ $t('no') }}
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex';
import Label from '@/components/Label.vue';
import MoneyFormat from 'vue-money-format';

export default {
  name: 'OrderPage',
  components: {
    Label,
    'money-format': MoneyFormat,
  },
  data () {
    return {
      order: {},
      loading: false,
      orderId: '',
      confirmCancelOrder: false,
      orderStatuses: [],
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
        { text: '', value: 'image', sortable: false, width: 80 },
        { text: this.$t('title'), value: 'title', sortable: false },
        { text: this.$t('price'), value: 'price', sortable: false },
        { text: this.$t('amount'), value: 'amount', sortable: false },
        { text: this.$t('sum'), value: 'sum', sortable: false },
      ]
    },
    orderSum () {
      let sum = 0;

      if (this.order.products) {
        for (const item of this.order.products) {
          sum += this.getItemPrice(item) * item.amount;
        }
      }

      return sum;
    },
  },
  mounted () {
    console.log('**');
    const orderId = this.$route.params.order;
    console.log('orderId', orderId);
    this.orderId = orderId;

    this.getOrder();
    this.getOrderStatuses();
  },
  methods: {
    async getOrderStatuses () {
      const graphqlQuery = {
        query: `
          query {
            orderStatuses (
              where: {}
            ) {
              id
              titleRu
              titleEn
              titleCh
              code
              color
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get order statuses response', response);

      const orderStatuses = response?.data?.data?.orderStatuses;

      this.orderStatuses = orderStatuses;
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
    async getOrder () {
      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            order (
              where: {
                id: "${this.orderId}"
              }
            ) {
              id
              products
              seller {
                id
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

      console.log('Get order response', response);

      const order = response?.data?.data?.order;

      if (order) {
        if (order.products) {
          order.products = JSON.parse(order.products.replace(/'/g, '"'));
        }

        order.products = await this.getOrderProducts(order.products);

        this.order = order;
      }

      this.loading = false;
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
    async copyOrderIdToClipboard () {
      try {
        await navigator.clipboard.writeText(this.orderId);
        console.log('Content copied to clipboard', this.orderId);
      } catch (err) {
        console.error('Failed to copy: ', err);
      }
    },
    async cancelOrder () {
      this.loading = true;

      const cancelStatus = this.orderStatuses.find(status => status.code === 'cancel');

      const graphqlQuery = {
        query: `
          mutation {
            updateOrder (
              where: {
                id: "${this.order.id}"
              }
              data: {
                status: {
                  connect: {
                    id: "${cancelStatus.id}"
                  }
                }
              }
            ) {
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

      console.log('Cancel order response', response);

      const order = response?.data?.data?.order;

      if (order) {
        if (order.products) {
          order.products = JSON.parse(order.products.replace(/'/g, '"'));
        }

        this.order = order;
      }

      this.loading = false;
    }
  }
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

    .item-image {
      width: 60px;
      height: 60px;
      background-size: contain;
      background-repeat: no-repeat;
      background-position: center;
    }
  }
</style>
