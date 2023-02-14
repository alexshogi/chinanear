<template>
  <v-container
    ref="page"
    class="orders-page"
    style="margin-top: 52px;"
  >
    <h1 class="mb-4">{{ $t('orders') }}</h1>
    <v-tabs v-model="tab">
      <v-tab
        v-for="item in tabItems"
        :key="item.tab"
        class="ml-3"
      >
        {{ item.tab }}
      </v-tab>
    </v-tabs>

    <v-tabs-items v-model="tab">
      <v-tab-item
        v-for="item in tabItems"
        :key="item.tab"
      >
        <v-card flat>
          <v-card-text>
            <component :is="item.content" />
          </v-card-text>
        </v-card>
      </v-tab-item>
    </v-tabs-items>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex';

import OrdersSeller from '@/components/orders/OrdersSeller';
import OrdersCustomer from '@/components/orders/OrdersCustomer';
import OrdersAll from '@/components/orders/OrdersAll';

export default {
  name: 'OrderPage',
  components: {
    OrdersCustomer,
    OrdersSeller,
    OrdersAll,
  },
  data() {
    return {
      tab: null,
    }
  },
  computed: {
    ...mapGetters({
      user: 'user'
    }),
    tabItems () {
      return [
        { tab: this.$t('i-buy'), content: 'OrdersCustomer' },
        { tab: this.$t('i-sell'), content: 'OrdersSeller' },
        { tab: this.$t('all'), content: 'OrdersAll' },
      ]
    },
  },
  methods: {}
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
