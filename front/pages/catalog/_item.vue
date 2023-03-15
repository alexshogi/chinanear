<template>
  <v-container
    ref="page"
    class="catalog-page"
    style="margin-top: 52px;"
  >
    <v-row>
      <v-col cols="12" class="pb-0">
        <v-breadcrumbs :items="breadcrumbs" class="pl-0">
          <template v-slot:divider>
            <v-icon>mdi-chevron-right</v-icon>
          </template>
        </v-breadcrumbs>
      </v-col>
    </v-row>
    <v-row>
      <v-col
        cols="9"
      >
        <v-card
          flat
          class="pa-4"
        >
          <v-row>
            <v-col>
              <h1
                class="d-flex align-center"
              >
                {{ title }}
                <Label
                  v-if="myGood"
                  :value="$t('my-product')"
                  color="orange"
                  class="ml-4"
                />
              </h1>
            </v-col>
          </v-row>
          <v-row class="pt-0 mt-0">
            <v-col
              cols="12"
              md="6"
            >
              <aside>
                <perfect-scrollbar>
                  <div 
                    v-if="item.images && item.images.length"
                    class="gallery-small"
                  >
                    <div
                      v-for="image in item.images"
                      :key="image.image.id"
                      :style="`background-image: url(${image.image.url})`"
                      class="gallery-small-image"
                      @click="openImage(image?.image)"
                    />
                  </div>
                </perfect-scrollbar>
                <div
                  class="main-image"
                  :style="`background-image: url(${item.image?.image?.url})`"
                  alt="MAIN PHOTO"
                  @click="openImage(item.image?.image)"
                />
              </aside>
            </v-col>
            <v-col
              cols="12"
              md="6"
              class="pt-9"
            >
              <h2 class="mb-2">{{ $t('short-description') }}</h2>
              <p>{{ caption }}</p>

              <h2 class="mt-8 mb-3">{{$t('price')}}</h2>
              <v-simple-table
                height="100px"
              >
                <template v-slot:default>
                  <thead>
                    <tr>
                      <th
                        v-for="interval in intervals"
                        :key="interval.to"
                        class="text-left"
                      >
                        {{ interval.from }} - {{ interval.to }} шт
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td
                        v-for="interval in intervals"
                        :key="interval.to"
                      >
                        <money-format
                          :value="interval.price"
                          :locale="$i18n.locale"
                          :currency-code="currency.code"
                        />
                      </td>
                    </tr>
                  </tbody>
                </template>
              </v-simple-table>
              <p
                v-if="!myGood"
                class="mt-3"
              >
                <v-btn
                  color="primary"
                  depressed
                  small
                  tile
                  style="text-transform: none; letter-spacing: normal;"
                >
                  {{ $t('offer-your-price') }}
                </v-btn>
              </p>
            </v-col>
          </v-row>
          <v-row class="mb-4">
            <v-col v-if="description">
              <h2 class="mb-4 text-center">{{$t('product-information')}}</h2>
              <div v-html="description"></div>
            </v-col>
          </v-row>
        </v-card>
      </v-col>

      <v-col
        v-if="!myGood"
        cols="3"
      >
        <v-card
          flat
          class="pa-7"
        >
          <v-card-text>
            <p
              class="mb-4 pa-0 text-center"
              style="font-size: 12px; line-height: 16px; color: #9E9E9E;"
            >
              {{$t('why-contact-seller')}}
            </p>
            <p class="text-center">
              <NuxtLink
                :to="`/chat?seller=${item.seller?.id}`"
                style="text-decoration: none; font-size: 12px; line-height: 16px;"
              >
                {{ $t('chat-with-seller') }}
              </NuxtLink>
            </p>
          </v-card-text>
          <v-card-actions>
            <v-btn
              color="headerOrange"
              depressed
              style="letter-spacing: normal; width: 100%; color: #FFFFFF; font-weight: 700; font-size: 14px; line-height: 17px; padding: 20px;"
              :disabled="isProductInCart"
              @click="addToCart(item)"
            >
              {{ isProductInCart ? $t('in-cart') : $t('add-to-cart') }}
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>

    <v-dialog
      v-model="imageDialog"
      width="800"
    >
      <div
        v-if="imageDialogImage.url"
        class="dialog-image"
        :style="`background-image: url(${imageDialogImage.url})`"
      />
    </v-dialog>
  </v-container>
</template>

<script>
import { mapGetters, mapActions } from 'vuex';
import { PerfectScrollbar } from 'vue2-perfect-scrollbar';
import MoneyFormat from 'vue-money-format';
import Label from '@/components/Label.vue';

export default {
  auth: false,
  name: 'ItemPage',
  components: {
    PerfectScrollbar,
    Label,
    MoneyFormat,
  },
  data () {
    return {
      imageDialog: false,
      imageDialogImage: {},
      loading: false,
      breadcrumbs: [
        {
          text: 'Компьютеры и оргтехника',
          disabled: false,
          href: '/',
        },
        {
          text: 'Комплектующие для ПК',
          disabled: false,
          href: '/',
        },
        {
          text: 'Видеокарты',
          disabled: true,
          href: '/',
        }
      ],
      item: {}
    }
  },
  computed: {
    ...mapGetters({
      cartProducts: 'cartProducts',
      user: 'user',
      currency: 'currency',
      currencyRates: 'currencyRates',
    }),
    intervals () {
      if (!this.item.intervals) {
        return [];
      }

      let intervals = this.item.intervals.replaceAll('*', '"');
      intervals = JSON.parse(intervals);

      return intervals;
    },
    myGood () {
      return this.item?.seller?.id === this.user?.id
    },
    goodCols () {
      return this.myGood ? '12' : '9'
    },
    isProductInCart () {
      return this.cartProducts.some(p => p.id === this.item.id);
    },
    title () {
      if (this.$i18n.locale === 'ru') return this.item.titleRu;
      if (this.$i18n.locale === 'en') return this.item.titleEn;
      if (this.$i18n.locale === 'ch') return this.item.titleCh;
    },
    caption () {
      if (this.$i18n.locale === 'ru') return this.item.captionRu;
      if (this.$i18n.locale === 'en') return this.item.captionEn;
      if (this.$i18n.locale === 'ch') return this.item.captionCh;
    },
    description () {
      if (this.item && this.$i18n.locale === 'ru') return this.item.descriptionRu;
      if (this.item && this.$i18n.locale === 'en') return this.item.descriptionEn;
      if (this.item && this.$i18n.locale === 'ch') return this.item.descriptionCh;

      return '';
    },
  },
  async mounted () {
    const itemId = this.$route.params.item;

    this.getProduct(itemId);
  },
  methods: {
    ...mapActions({
      addProductToCart: 'addProductToCart',
    }),
    addToCart (product) {
      this.addProductToCart({
        ...product,
        amount: 1
      });

      if (this.user) {
        this.handleCart();
      }
    },
    async handleCart () {
      const graphqlQuery = {
        query: `
          query {
            cart (
              where: {
                userId: "${this.user.id}"
              }
            ) {
              id
              products
              userId
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Handle cart response', response);

      const cart = response?.data?.data?.cart;

      if (cart) {
        this.updateCart();
      } else {
        this.createCart();
      }
    },
    async createCart () {
      const graphqlQuery = {
        query: `
          mutation {
            createCart (
              data: {
                products: "${JSON.stringify(this.cartProducts).replace(/"/g, '\'')}",
                userId: "${this.user.id}"
              }
            ) {
              id
              products
              userId
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Create cart response', response);
    },
    openImage (image) {
      if (image?.url) {
        this.imageDialogImage = image;

        this.imageDialog = true;
      }
    },
    async updateCart () {
      const graphqlQuery = {
        query: `
          mutation {
            updateCart (
              where: {
                id: "clczunq5w0081qldu3pkjntr1"
              }
              data: {
                products: "${JSON.stringify(this.cartProducts).replace(/"/g, '\'')}"
              }
            ) {
              id
              products
              userId
            }
          }
        `
      };

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Update cart response', response);
    },
    async getProduct (id) {
      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            product(where: { id: "${id}" }) {
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

      if (response?.data?.data?.product) {
        this.item = response.data.data.product;
        this.activePhoto = this.item.image?.image?.url;
      }

      this.loading = false;
    }
  }
}
</script>

<style src="vue2-perfect-scrollbar/dist/vue2-perfect-scrollbar.css"/>

<style>
  .ps {
    height: 400px;
    width: 110px;
    min-width: 110px;
  }

  .ps__rail-y {
    right: 0 !important;
  }

  .ps__rail-x {
    display: none !important;
  }
</style>

<style lang="scss" scoped>
  h1 {
    font-weight: 600;
    font-size: 32px;
    line-height: 44px;
    letter-spacing: 0.02em;
    color: #424242;
  }

  h2 {
    font-weight: 600;
    font-size: 20px;
    line-height: 27px;
    letter-spacing: 0.02em;
    color: #424242;
  }

  p {
    font-weight: 400;
    font-size: 14px;
    line-height: 19px;
    letter-spacing: 0.01em;
    color: #616161;
  }

  .dialog-image {
    height: 600px;
    width: 100%;
    background-size: contain;
    background-repeat: no-repeat;
    background-position: center;
    background-color: #FFFFFF;
  }

  aside {
    padding: 24px;
    padding-left: 0px;
    padding-right: 0px;
    display: flex;
    flex-direction: row;
    justify-content: space-between;

    .main-image {
      width: 100%;
      width: 400px;
      max-width: calc(100% - 20px);
      height: 400px;
      margin: 0 auto;
      background-size: contain;
      background-repeat: no-repeat;
      background-position: center;
      cursor: pointer;
    }

    .gallery-small {
      display: flex;
      min-width: 100px;
      flex-direction: column;
      height: 400px;
      margin-right: 12px;

      .gallery-small-image {
        margin-bottom: 5px;
        width: 100px;
        height: 75px;
        min-width: 100px;
        min-height: 75px;
        max-width: 100px;
        max-height: 75px;
        cursor: pointer;
        border-left: 2px solid transparent;
        background-color: #FFFFFF;
        background-position: center;
        background-repeat: no-repeat;
        background-size: contain;

        &.active {
          border-left: 2px solid #FF9B00;
        }
      }
    }
  }
</style>
