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
            {{ c.titleRu }}
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
    }
  },
  mounted() {
    this.getCats();
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
