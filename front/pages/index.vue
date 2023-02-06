<template>
  <v-container
    ref="page"
    class="index-page"
    style="margin-top: 52px;"
  >
    <v-row class="mt-2">
      <v-col cols="12">
        <img
          height="175"
          width="100%"
          src="../static/welcome-desktop.webp"
          alt="Добро пожаловать"
        >
      </v-col>
    </v-row>

    <v-row class="mt-2">
      <v-col cols="12">
        <h3>{{ $t('best-sellers') }}</h3>
        <v-row class="mt-2">
          <v-col cols="12">
            <ViewsCards
              :data="goods"
              :loading="loading"
              row
              @open-goods="openGoodsItem"
            />
          </v-col>
        </v-row>
      </v-col>
    </v-row>

    <v-row class="mt-4">
      <v-col cols="12">
        <NuxtLink
          to="/catalog"
          style="text-decoration: none;"
        >
          <v-btn
            color="primary"
            depressed
            style="text-transform: none; letter-spacing: normal;"
          >
            {{ $t('go-to-catalog') }}
          </v-btn>
        </NuxtLink>
      </v-col>
    </v-row>

    <v-row class="mt-8">
      <v-col>
        <h3>
          {{ $t('popular-categories') }}
          <NuxtLink
            to="/categories"
            style="text-decoration: none;"
          >
            <span
              style="text-transform: none; font-weight: 400; font-size: 14px; padding-left: 10px;"
            >
              {{ $t('show-all') }}
            </span>
          </NuxtLink>
        </h3>
        <section class="mt-5 cats-container">
          <NuxtLink
            v-for="c in popularCats"
            :key="c.id"
            :to="`/catalog?category=${c.code}`"
            style="text-decoration: none;"
          >
            <v-card
              class="pa-4 cat-card"
              flat
              style="flex: 1;"
            >
              <h4
                style="text-transform: none; font-size: 18px; font-weight: 600; color: #474747; letter-spacing: normal;"
              >
                {{ $i18n.locale === 'en' ? c.titleEn : c.titleRu }}
              </h4>
              <div
                class="cat-image"
                :style="{ backgroundImage: `url(/categories/${c.code}.png)` }"
              />
            </v-card>
          </NuxtLink>
        </section>
      </v-col>
    </v-row>

    <v-row class="mt-4">
      <v-col cols="12">
        <NuxtLink
          to="/catalog"
          style="text-decoration: none;"
        >
          <v-btn
            color="primary"
            depressed
            style="text-transform: none; letter-spacing: normal;"
          >
            {{ $t('go-to-catalog') }}
          </v-btn>
        </NuxtLink>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import ViewsCards from '@/components/Goods/ViewsCards.vue'

export default {
  auth: false,
  name: 'IndexPage',
  components: {
    ViewsCards,
  },
  data () {
    return {
      loading: false,
      goods: [],
      categories: [],
    }
  },
  computed: {
    popularGoods () {
      return this.goods.slice(0, 5);
    },
    popularCats () {
      return this.categories.slice(0, 4);
    }
  },
  mounted () {
    this.getCats();
    this.getGoods();
  },
  methods: {
    openGoodsItem (item) {
      console.log('** openGoodsItem')
      console.log(item)

      this.$router.push({ path: `catalog/${item}` });
    },
    async getGoods () {
      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            products {
              id
              title
              caption
              balance
              image {
                url
              }
              isActive
              intervals
              category1
              category2
              category3
              seller {
                companyName
                companyMarketNameRu
                companyMarketNameEn
              }
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      if (response?.data?.data?.products) {
        this.goods = [...response.data.data.products];
      }

      this.loading = false;
    },
    async getCats () {
      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            categories(where: {}) {
              id
              code
              isActive
              titleRu
              titleEn
              children {
                id
                code
                isActive
                titleRu
                titleEn
              }
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      if (response?.data?.data?.categories) {
        this.categories = [...response.data.data.categories];
      }

      this.loading = false;
    }
  }
}
</script>

<style lang="scss" scoped>
.cats-container {
  grid-gap: 20px;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  background-color: #fafafa;
  padding: 20px;

  .cat-card {
    min-height: 180px;
    background-color: #efefef;
    position: relative;

    &:hover h4 {
      color: #FF7419 !important;
    }

    h4 {
      max-width: 70%;
      transition: all 0.27s;
    }

    .cat-image {
      position: absolute;
      bottom: 0;
      right: 0;
      width: 120px;
      height: 120px;
      background-size: contain;
      background-position: center;
      background-repeat: no-repeat;
    }
  }
}
</style>
