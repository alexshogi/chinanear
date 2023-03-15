<template>
  <v-container
    ref="page"
    class="add-good-page"
    style="margin-top: 52px;"
  >
    <v-row>
      <v-col>
        <v-card
          flat
          class="pa-4"
        >
          <div class="d-flex justify-space-between align-center pb-4">
            <h1>Редактировать товар</h1>
            <v-btn
              color="primary"
              depressed
              @click="updateProduct"
            >
              Сохранить
            </v-btn>
          </div>

          <div class="divider" />

          <v-row class="mt-2">
            <v-col cols="12">
              <h2>Изображения товара</h2>
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
              class="d-flex"
            >
              <section class="main-image">
                <picture-input
                  ref="mainPictureInput"
                  width="288"
                  height="288"
                  accept="image/*"
                  size="5"
                  type="main"
                  button-class="btn-hidden"
                  :prefill="image?.image?.url"
                  @change="onMainImageChange"
                  @remove="removeMainImage"
                />
              </section>

              <section class="images">
                <div
                  v-for="elem in 5"
                  :key="elem"
                  class="image"
                >
                  <picture-input
                    ref="pictureInput"
                    width="128"
                    height="128"
                    accept="image/*"
                    size="5"
                    type="regular"
                    button-class="btn-hidden"
                    :prefill="getUrl(elem)"
                    @change="onImageChange($event, elem)"
                    @remove="removeImage(elem)"
                  />
                </div>
              </section>
            </v-col>
          </v-row>

          <v-row class="mt-4">
            <v-col cols="12">
              <h2>Наименование и описание товара</h2>
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
              class="d-flex align-center"
            >
              <img
                width="22px"
                height="17px"
                src="@/static/flag_ru.png"
                alt="RU"
                class="mr-3"
                style="box-shadow: 0 0 2px 2px #d5d5d5;"
              >
              RU
              <v-text-field
                v-model="titleRu"
                label="Наименование товара на русском языке"
                class="ml-4"
                dense
                hide-details
                outlined
              />
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
            >
              <v-text-field
                v-model="captionRu"
                label="Краткое описание товара на русском языке"
                dense
                hide-details
                outlined
              />
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
            >
              <ClientOnly>
                <tiptap-vuetify
                  v-model="descriptionRu"
                  :extensions="extensions"
                  placeholder="Подробное описание товара на русском языке"
                />
              </ClientOnly>
            </v-col>
          </v-row>

          <v-row class="mt-10 mb-8">
            <div class="divider" />
          </v-row>

          <v-row>
            <v-col
              cols="12"
              class="d-flex align-center"
            >
              <img
                width="22px"
                height="16px"
                src="@/static/flag_en.png"
                alt="GB"
                class="mr-3"
                style="box-shadow: 0 0 5px 2px #d5d5d5;"
              >
              GB
              <v-text-field
                v-model="titleEn"
                label="Product name in English"
                class="ml-4"
                dense
                hide-details
                outlined
              />
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
            >
              <v-text-field
                v-model="captionEn"
                label="Brief product description in English"
                dense
                hide-details
                outlined
              />
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
            >
              <ClientOnly>
                <tiptap-vuetify
                  v-model="descriptionEn"
                  :extensions="extensions"
                  placeholder="Detailed product description in English"
                />
              </ClientOnly>
            </v-col>
          </v-row>

          <v-row class="mt-10 mb-8">
            <div class="divider" />
          </v-row>

          <v-row>
            <v-col
              cols="12"
              class="d-flex align-center"
            >
              <img
                width="25px"
                height="16px"
                src="@/static/flag_ch.png"
                alt="CH"
                class="mr-3"
                style="box-shadow: 0 0 5px 2px #d5d5d5;"
              >
              CH
              <v-text-field
                v-model="titleCh"
                label="中文產品名稱"
                class="ml-4"
                dense
                hide-details
                outlined
              />
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
            >
              <v-text-field
                v-model="captionCh"
                label="中文產品簡介"
                dense
                hide-details
                outlined
              />
            </v-col>
          </v-row>

          <v-row>
            <v-col
              cols="12"
            >
              <ClientOnly>
                <tiptap-vuetify
                  v-model="descriptionCh"
                  :extensions="extensions"
                  placeholder="中文詳細的產品描述"
                />
              </ClientOnly>
            </v-col>
          </v-row>

          <v-row class="mt-4">
            <v-col cols="12">
              <h2>Выберите категорию товара</h2>
            </v-col>
          </v-row>

          <v-row>
            <v-col>
              <v-select
                v-model="selectedCategory"
                :items="categories"
                return-object
                item-text="titleRu"
                label="Category 1st level"
                outlined
                dense
              />
            </v-col>

            <v-col>
              <v-select
                v-model="selectedSubCategory"
                :items="subCategories"
                :disabled="!selectedCategory.id"
                return-object
                item-text="titleRu"
                label="Category 2nd level"
                outlined
                dense
              />
            </v-col>

            <v-col>
              <v-select
                v-model="selectedSubSubCategory"
                :items="subSubCategories"
                :disabled="!selectedSubCategory.id"
                return-object
                item-text="titleRu"
                label="Category 3rd level"
                outlined
                dense
              />
            </v-col>
          </v-row>

          <v-row class="mt-4">
            <v-col cols="12">
              <h2>Введите остатки, количество и стоимость товара</h2>
            </v-col>
          </v-row>

          <v-row>
            <v-col cols="3">
              <v-text-field
                v-model="balance"
                label="Stock"
                placeholder="0"
                outlined
                dense
              />
            </v-col>

            <v-col cols="9">
              <v-row>
                <v-col cols="3">
                  <v-text-field
                    v-model="priceRow.from"
                    label="Quantity from"
                    placeholder="0"
                    outlined
                    type="number"
                    step="1"
                    dense
                    min="0"
                  />
                </v-col>
                <v-col cols="3">
                  <v-text-field
                    v-model="priceRow.to"
                    label="Quantity to"
                    placeholder="0"
                    outlined
                    type="number"
                    step="1"
                    dense
                    min="0"
                  />
                </v-col>
                <v-col cols="3">
                  <v-text-field
                    v-model="priceRow.price"
                    label="Price"
                    prefix="$"
                    placeholder="0"
                    outlined
                    type="number"
                    step="1"
                    dense
                    min="0"
                  />
                </v-col>
                <v-col cols="3">
                  <v-btn
                    text
                    @click="addPriceRow"
                  >
                    <v-icon left>
                      mdi-plus
                    </v-icon>
                    Добавить
                  </v-btn>
                </v-col>
              </v-row>

              <v-row
                v-for="(row, index) in rows"
                :key="index"
              >
                <v-col cols="3">
                  <v-text-field
                    v-model="row.from"
                    label="Quantity from"
                    placeholder="0"
                    outlined
                    type="number"
                    step="1"
                    dense
                    min="0"
                  />
                </v-col>
                <v-col cols="3">
                  <v-text-field
                    v-model="row.to"
                    label="Quantity to"
                    placeholder="0"
                    outlined
                    type="number"
                    step="1"
                    dense
                    min="0"
                  />
                </v-col>
                <v-col cols="3">
                  <v-text-field
                    v-model="row.price"
                    label="Price"
                    prefix="$"
                    placeholder="0"
                    outlined
                    type="number"
                    step="1"
                    dense
                    min="0"
                  />
                </v-col>
                <v-col cols="3">
                  <v-btn
                    text
                    @click="deletePriceRow(index)"
                  >
                    <v-icon>
                      mdi-delete
                    </v-icon>
                  </v-btn>
                </v-col>
              </v-row>
            </v-col>
          </v-row>

          <v-row
            class="pa-6"
          >
            <v-btn
              class="mr-6"
              depressed
              outlined
              color="red"
              @click="close"
            >
              Закрыть
            </v-btn>

            <v-btn
              depressed
              color="primary"
              @click="updateProduct"
            >
              Сохранить
            </v-btn>
          </v-row>

        </v-card>
      </v-col>
    </v-row>

    <v-snackbar
      v-model="snackbar"
      :timeout="4000"
    >
      Товар успешно обновлён
    </v-snackbar>
  </v-container>
</template>

<script>
import { mapGetters } from 'vuex';
import {
  TiptapVuetify,
  Heading,
  Bold,
  Italic,
  Strike,
  Underline,
  Code,
  Paragraph,
  BulletList,
  OrderedList,
  ListItem,
  Link,
  Blockquote,
  HardBreak,
  HorizontalRule,
  History
} from 'tiptap-vuetify';
import PictureInput from '@/components/PictureInput.vue';

export default {
  name: 'GoodsPage',
  components: {
    PictureInput,
    TiptapVuetify,
  },
  data () {
    return {
      product: {},
      extensions: [
        History,
        Blockquote,
        Link,
        Underline,
        Strike,
        Italic,
        ListItem,
        BulletList,
        OrderedList,
        [
          Heading,
          {
            options: {
              levels: [1, 2, 3]
            }
          }
        ],
        Bold,
        Link,
        Code,
        HorizontalRule,
        Paragraph,
        HardBreak
      ],
      image: null,
      images: [],
      imageIndex: 0,
      titleRu: '',
      titleEn: '',
      titleCh: '',
      captionRu: '',
      captionEn: '',
      captionCh: '',
      descriptionRu: '',
      descriptionEn: '',
      descriptionCh: '',
      categories: [],
      subCategories: [],
      subSubCategories: [],
      selectedCategory: {},
      selectedSubCategory: {},
      selectedSubSubCategory: {},
      balance: 0,
      priceRow: {
        from: 1,
        to: 99,
        price: 100
      },
      priceRows: [],
      snackbar: false,
    }
  },
  computed: {
    ...mapGetters({
      user: 'user',
      currency: 'currency',
      currencyRates: 'currencyRates',
    }),
    rows () {
      return [...this.priceRows];
    }
  },
  async mounted () {
    await this.fetchCategories();
    await this.fetchSubCategories();
    await this.fetchSubSubCategories();
    await this.getProduct();
  },
  methods: {
    getUrl (index) {
      if (this.images[index - 1]) {
        return this.images[index - 1].image.url;
      }

      return '';
    },
    async getProduct () {
      const itemId = this.$route.params.item;

      this.loading = true;

      const graphqlQuery = {
        query: `
          query {
            product (
              where: {
                id: "${itemId}"
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
                id
                image {
                  id
                  filesize
                  width
                  height
                  extension
                  url
                }
              }
              images {
                id
                image {
                  id
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

      console.log('Get product response', response);

      const product = response?.data?.data?.product;

      this.loading = false;

      this.product = product;

      let intervals = [];

      if (product.intervals) {
        intervals = product.intervals.replaceAll('*', '"');
        intervals = JSON.parse(intervals);

        if (intervals?.length) {
          const firstInterval = intervals[0];
          const otherIntervals = intervals.slice(1) || [];

          this.priceRow = firstInterval;
          this.priceRows = otherIntervals;
        }
      }

      this.image = product.image
      this.images = product.images
      this.titleRu = product.titleRu
      this.titleEn = product.titleEn
      this.titleCh = product.titleCh
      this.captionRu = product.captionRu
      this.captionEn = product.captionEn
      this.captionCh = product.captionCh
      this.descriptionRu = product.descriptionRu
      this.descriptionEn = product.descriptionEn
      this.descriptionCh = product.descriptionCh
      this.selectedCategory = product.category
      this.selectedSubCategory = product.subCategory
      this.selectedSubSubCategory = product.subSubCategory
      this.balance = product.balance
    },
    addPriceRow () {
      this.priceRows.push({
        from: 1,
        to: 99,
        price: 100
      });
    },
    deletePriceRow (index) {
      this.priceRows.splice(index, 1);
    },
    async onMainImageChange (image) {
      if (image) {
        this.image = image
      }

      await this.uploadMainImageToBack();
    },
    async onImageChange (image, elem) {
      await this.uploadImageToBack(image, elem);
    },
    removeMainImage () {
      this.image = null;
    },
    removeImage (elem) {
      this.images[elem - 1] = null;
    },
    async fetchCategories () {
      const graphqlQuery = {
        query: `
          query {
            categories {
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
      }

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get categories response', response);

      const categories = response?.data?.data?.categories;

      if (categories) {
        this.categories = categories
      }

      this.loading = false;
    },
    async fetchSubCategories () {
      const graphqlQuery = {
        query: `
          query {
            subCategories {
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
      }

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get sub categories response', response);

      const categories = response?.data?.data?.subCategories;

      if (categories) {
        this.subCategories = categories
      }

      this.loading = false;
    },
    async fetchSubSubCategories () {
      const graphqlQuery = {
        query: `
          query {
            subSubCategories {
              id
              code
              isActive
              titleRu
              titleEn
              titleCh
            }
          }
        `
      }

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Get sub sub categories response', response);

      const categories = response?.data?.data?.subSubCategories;

      if (categories) {
        this.subSubCategories = categories
      }

      this.loading = false;
    },
    async uploadMainImageToBack () {
      console.log('=> uploadMainImageToBack');
      const file = this.$refs['mainPictureInput'].file;

      const query = `
        mutation($file: Upload!) {
          createImage (
            data: {
              image: {
                upload: $file
              }
              name: "${file.name}"
            }
          ) {
            id
            name
            image {
              id
              url
              width
              height
              filesize
              extension
            }
          }
        }
      `;

      const variables = {
        file: file
      }

      const request = await this.prepareGraphQLRequest(query, variables);

      const response = await fetch('http://localhost:3000/api/graphql', request);
      const responseBody = await response.text();
      const result = JSON.parse(responseBody);

      console.log('Upload image response', result);

      if (result?.data?.createImage) {
        const imageCreated = result.data.createImage;

        this.image = imageCreated;

        console.log(this.image);

        return imageCreated;
      }

      return null;
    },
    async uploadImageToBack (image, elem) {
      const file = this.$refs['pictureInput'][elem - 1].file;

      const query = `
        mutation($file: Upload!) {
          createImage (
            data: {
              image: {
                upload: $file
              }
              name: "${file.name}"
            }
          ) {
            id
            name
            image {
              id
              url
              width
              height
              filesize
              extension
            }
          }
        }
      `;

      const variables = {
        file: file
      }

      const request = await this.prepareGraphQLRequest(query, variables);

      const response = await fetch('http://localhost:3000/api/graphql', request);
      const responseBody = await response.text();
      const result = JSON.parse(responseBody);

      console.log('Upload image response', result);

      if (result?.data?.createImage) {
        const imageCreated = result.data.createImage;

        this.images[elem - 1] = imageCreated;

        console.log(this.images);

        return imageCreated;
      }

      return null;
    },
    async prepareGraphQLRequest(query, variables) {
      let request;

      const data = {
        operations: JSON.stringify({
          query,
          variables: {
            ...variables,
            file: null
          }
        }),
        map: JSON.stringify({
          '0': [
            'variables.file'
          ]
        })
      };

      const requestBody = new FormData();

      for (const name in data) {
        requestBody.append(name, data[name]);
      }

      requestBody.append('0', variables.file);

      request = {
        method: 'POST',
        body: requestBody
      }

      return request;
    },
    close () {
      this.$router.push({ name: 'goods' });
    },
    async updateProduct () {
      console.log('=> updateProduct');
      const itemId = this.$route.params.item;

      console.log('image', this.image);
      console.log('images', this.images);
      console.log('titleRu', this.titleRu);
      console.log('titleEn', this.titleEn);
      console.log('titleCh', this.titleCh);
      console.log('captionRu', this.captionRu);
      console.log('captionEn', this.captionEn);
      console.log('captionCh', this.captionCh);
      console.log('descriptionRu', this.descriptionRu);
      console.log('descriptionEn', this.descriptionEn);
      console.log('descriptionCh', this.descriptionCh);
      console.log('selectedCategory', this.selectedCategory);
      console.log('selectedSubCategory', this.selectedSubCategory);
      console.log('selectedSubSubCategory', this.selectedSubSubCategory);
      console.log('balance', this.balance);
      console.log('priceRow', this.priceRow);
      console.log('priceRows', this.priceRows);

      const priceRowsAll = [ this.priceRow, ...this.priceRows ];
      let priceRowsAllString = JSON.stringify(priceRowsAll);
      priceRowsAllString = priceRowsAllString.replaceAll('"', '*');

      let imageString = '';

      if (this.image) {
        imageString = `image: { connect: { id: "${this.image.id}" } }`;
      }

      let imagesString = '';

      if (this.images.length) {
        imagesString += 'images: { connect: [ ';

        for (const image of this.images) {
          if (image) {
            imagesString += `{ id: "${this.image.id}" } `;
          }
        }

        imagesString += '] }';
      }

      let categoryString = '';

      if (this.selectedCategory?.id) {
        categoryString = `category: { connect: { id: "${this.selectedCategory.id}" } }`;
      }

      let subCategoryString = '';

      if (this.selectedSubCategory?.id) {
        subCategoryString = `subCategory: { connect: { id: "${this.selectedSubCategory.id}" } }`;
      }

      let subSubCategoryString = '';

      if (this.selectedSubCategory?.id) {
        subSubCategoryString = `subSubCategory: { connect: { id: "${this.selectedSubSubCategory.id}" } }`;
      }

      const graphqlQuery = {
        query: `
          mutation {
            updateProduct(
              where: {
                id: "${itemId}"
              }
              data: {
                titleRu: "${this.titleRu.replaceAll('"', '')}"
                titleEn: "${this.titleEn.replaceAll('"', '')}"
                titleCh: "${this.titleCh.replaceAll('"', '')}"
                captionRu: "${this.captionRu.replaceAll('"', '')}"
                captionEn: "${this.captionEn.replaceAll('"', '')}"
                captionCh: "${this.captionCh.replaceAll('"', '')}"
                descriptionRu: "${this.descriptionRu.replaceAll('"', '')}"
                descriptionEn: "${this.descriptionEn.replaceAll('"', '')}"
                descriptionCh: "${this.descriptionCh.replaceAll('"', '')}"
                balance: ${this.balance}
                intervals: "${priceRowsAllString}"
                ${imageString}
                ${imagesString}
                ${categoryString}
                ${subCategoryString}
                ${subSubCategoryString}
                isActive: false
                author: {
                  connect: {
                    id: "${this.user.id}"
                  }
                }
                seller: {
                  connect: {
                    id: "${this.user.id}"
                  }
                }
              }
            ) {
              id
              titleRu
              titleEn
              balance
            }
          }
        `
      }

      const response = await this.$axios({
        method: 'POST',
        data: JSON.stringify(graphqlQuery)
      });

      console.log('Update product response', response);

      const productUpdated = response?.data?.data?.updateProduct;

      console.log('=> productUpdated', productUpdated);

      this.loading = false;
      this.snackbar = true;

      await this.getProduct();
    }
  }
}
</script>

<style>
  .btn-hidden {
    display: none;
  }

  .v-btn--fab {
    z-index: 14000 !important;
  }

  .v-btn--fab.v-size--x-small {
    height: 24px;
    width: 24px;
  }
</style>

<style lang="scss" scoped>
  .add-good-page {

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

    h2 {
      font-weight: 600;
      font-size: 20px;
      line-height: 27px;
      color: #616161;
    }

    .main-image {
      width: 288px;
      height: 288px;
      background: #FAFAFA;
      border: 1px solid #EEEEEE;
      border-radius: 4px;
      margin-right: 40px;
      position: relative;

      .main-image-preview {
        height: 100%;
        width: 100%;
        background-position: center;
        background-repeat: no-repeat;
        background-size: cover;
      }
    }

    .images {
      height: 288px;
      width: calc(100% - 288px - 40px);
      display: grid;
      gap: 32px;
      grid-template-columns: repeat(5, 128px);
      grid-template-rows: repeat(1, 128px);
      padding: 0 10px;

      .image {
        width: 128px;
        height: 128px;
        background: #F5F5F5;
        border: 1px solid #EEEEEE;
        border-radius: 2px;
      }
    }
  }
</style>
