<template>
  <v-container
    ref="page"
    class="catalog-page"
    style="margin-top: 52px;"
  >
    <v-row>
      <v-col cols="12" class="pb-0 d-flex justify-end align-center">
        <v-btn
          icon
          :color="showCards ? 'primary' : 'grey'"
          @click="showCards = true; showRows = false"
        >
          <v-icon>mdi-view-grid</v-icon>
        </v-btn>
        <v-btn
          icon
          :color="showRows ? 'primary' : 'grey'"
          @click="showRows = true; showCards = false"
        >
          <v-icon style="transform: scaleY(1.3);">mdi-view-sequential</v-icon>
        </v-btn>
      </v-col>
    </v-row>
    <v-row>
      <v-col cols="2">
        <aside>
          <v-card
            flat
          >
            <v-card-title class="d-flex justify-start align-center">
              <v-icon
                style="font-size: 18px;"
                class="mr-2"
              >
                mdi-format-list-bulleted
              </v-icon>
              <span
                style="font-weight: 600; font-size: 14px; line-height: 19px; color: #848484; margin-top: 3px;"
              >
                {{$t('categories')}}
              </span>
            </v-card-title>
            <v-card-text class="pa-0">
              <!-- <v-list-item
                v-for="cat in categories"
                :key="cat.id"
                class="px-4 py-0 category-item"
                :class="{ active: cat.selected }"
                dense
                style="color: #333333;"
                @click="setCategory(cat.code)"
              >
                <v-list-item-content>
                  <v-list-item-title>{{ $i18n.locale === 'en' ? cat.titleEn : cat.titleRu }}</v-list-item-title>
                </v-list-item-content>
              </v-list-item> -->
              <v-treeview
                activatable
                hoverable
                :item-text="getLang"
                open-on-click
                return-object
                :active="active"
                :items="categories"
                @update:active="setActiveCat"
              />
            </v-card-text>
          </v-card>
        </aside>
      </v-col>
      <v-col cols="10">
        <ViewsCards
          v-if="showCards"
          :data="filteredGoods"
          :loading="loading"
          @open-goods="openGoodsItem"
        />
        <ViewsList
          v-else
          :data="filteredGoods"
          :loading="loading"
          @open-goods="openGoodsItem"
        />
        <Pagination
          :pagination="pagination"
          :total-items="totalItems"
          @change="setPage"
        />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import ViewsCards from '@/components/Goods/ViewsCards.vue'
import ViewsList from '@/components/Goods/ViewsList.vue'
import Pagination from '@/components/Pagination'

export default {
  name: 'CatalogPage',
  components: {
    ViewsCards,
    ViewsList,
    Pagination,
  },
  data () {
    return {
      categories: [{
        id: 'all',
        code: 'all',
        titleRu: 'Все',
        titleEn: 'All',
        titleCh: 'All'
      }],
      category: '',
      active: [{ id: 'all' }],
      showCards: true,
      showRows: false,
      loading: false,
      goods: [],
      pagination: {
        page: 1,
        itemsPerPage: 10,
        rowsPerPageItems: [10, 20, 40]
      },
      totalItems: 0,
    }
  },
  computed: {
    filteredGoods () {
      if (this.category === 'all') {
        return this.goods;
      }

      return this.goods.filter(g => g.category?.code === this.category || g.subCategory?.code === this.category || g.subSubCategory?.code === this.category);
    },
    getLang () {
      if (this.$i18n.locale === 'ru') return 'titleRu';
      if (this.$i18n.locale === 'en') return 'titleEn';
      if (this.$i18n.locale === 'ch') return 'titleCh';
    }
  },
  async mounted () {
    this.category = this.$route.query?.category || 'all';

    await this.getCats();
    await this.getGoods();
  },
  methods: {
    openGoodsItem (id) {
      this.$router.push({ path: `catalog/${id}` });
    },
    setPage (pagination) {
      this.setPaginationPage(pagination.page)
      this.setPaginationItemsPerPage(pagination.itemsPerPage)
      this.pagination = pagination
    },
    checkActiveCat () {
      if (this.category === 'all') {
        return
      }

      const cat = this.categories.find(c => c.code === this.category);

      if (cat) {
        this.active = [{ id: cat.id, code: cat.code }];
      }
    },
    setActiveCat (cat) {
      const { code, id } = cat[0];
      console.log('code', code)
      console.log('id', id)

      if (!code && !id) {
        return;
      }

      this.category = code;
      this.active = [{ id: id }];

      console.log('active', this.active);

      // this.$router.push({
      //   path: this.$route.path,
      //   query: {
      //     ...this.$route.query,
      //     category: cat[0].code
      //   }
      // });
    },
    async getGoods () {
      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            products {
              id
              balance
              image {
                url
              }
              titleRu
              titleEn
              titleCh
              captionRu
              captionEn
              captionCh
              isActive
              intervals
              category {
                code
                titleRu
                titleEn
                titleCh
                isActive
              }
              subCategory {
                code
                titleRu
                titleEn
                titleCh
                isActive
              }
              subSubCategory {
                code
                titleRu
                titleEn
                titleCh
                isActive
              }
              seller {
                id
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
        this.goods = [...response.data.data.products.filter(p => p.isActive)];
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
              titleCh
              children {
                id
                code
                isActive
                titleRu
                titleEn
                titleCh
                children {
                  id
                  code
                  isActive
                  titleRu
                  titleEn
                  titleCh
                }
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
        this.categories = [ ...this.categories, ...response.data.data.categories ];
      }

      this.loading = false;

      this.checkActiveCat();
    },
    setPaginationPage (page) {

    },
    setPaginationItemsPerPage (itemsPerPage) {

    },
  }
}
</script>

<style>
  .v-treeview-node__root.v-treeview-node--active {
    color: #fafafa !important;
    background-color: #FF9B00 !important;
  }

  .v-treeview-node__root > .v-treeview-node__content > * {
    white-space: normal;
    height: fit-content;
    padding: 2px 0;
}
</style>

<style lang="scss" scoped>
  .v-list-item__title, .v-list-item__subtitle {
    overflow: unset;
    text-overflow: unset;
    white-space: unset;
  }
  .category-item {
    cursor: pointer;
    transition: all 0.28s;

    :hover {
      color: #FF9B00;
    }

    &.active {
      color: #ffffff !important;
      background-color: #FF9B00;
      pointer-events: none;
    }
  }
</style>
