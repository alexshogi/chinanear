<template>
  <v-container ref="page" class="categories-page" style="margin-top: 52px;">
    <v-row v-if="loading">
      <v-progress-circular v-if="loading" indeterminate size="20" width="3" color="primary" />
    </v-row>

    <div v-else class="cats-container">
      <NuxtLink v-for="c in categories" :key="c.id" :to="`/catalog?category=${c.code}`" style="text-decoration: none;">
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
    </div>
  </v-container>
</template>

<script>
export default {
  auth: false,
  name: 'CategoriesPage',
  data() {
    return {
      loading: false,
      categories: [],
      subCategories: [],
      subSubCategories: [],
    }
  },
  async mounted() {
    await this.getCats();
    await this.getSubCats();
    await this.getSubSubCats();
  },
  methods: {
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
    },
    async getSubCats () {
      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            subCategories(where: {}) {
              id
              code
              isActive
              titleRu
              titleEn
              titleCh
              parent {
                id
                code
                isActive
                titleRu
                titleEn
                titleCh
              }
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
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      if (response?.data?.data?.subCategories) {
        this.subCategories = [...response.data.data.subCategories];
      }

      this.loading = false;
    },
    async getSubSubCats () {
      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            subSubCategories(where: {}) {
              id
              code
              isActive
              titleRu
              titleEn
              titleCh
              parent {
                id
                code
                isActive
                titleRu
                titleEn
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

      if (response?.data?.data?.subSubCategories) {
        this.subSubCategories = [...response.data.data.subSubCategories];
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
