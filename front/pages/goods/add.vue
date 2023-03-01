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
            <h1>Новый товар</h1>
            <v-btn
              color="primary"
              depressed
              style="letter-spacing: normal; width: 100%; color: #FFFFFF; font-weight: 600; font-size: 14px; line-height: 17px; padding: 20px; width: fit-content"
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
                  ref="pictureInput"
                  width="288"
                  height="288"
                  accept="image/*"
                  size="5"
                  type="main"
                  button-class="btn-hidden"
                  @change="onMainImageChange"
                  @remove="removeMainImage"
                />
              </section>

              <section class="images">
                <div
                  v-for="elem in 6"
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
                src="../../static/flag_ru.png"
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
              <Editor :text="descriptionRu" />
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
                src="../../static/flag_en.png"
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
              <Editor :text="descriptionEn" />
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
                src="../../static/flag_ch.png"
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
              <Editor :text="descriptionCh" />
            </v-col>
          </v-row>

          <v-row class="mt-4">
            <v-col cols="12">
              <h2>Выберите категорию товара</h2>
            </v-col>
          </v-row>

          <v-row class="mt-4">
            <v-col cols="12">
              <h2>Выберите единицы измерения, введите остатки, количество и стоимость товара</h2>
            </v-col>
          </v-row>

        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import PictureInput from '@/components/PictureInput.vue';
import Editor from '@/components/Editor';

export default {
  name: 'GoodsPage',
  components: {
    PictureInput,
    Editor,
  },
  data () {
    return {
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
    }
  },
  computed: {

  },
  methods: {
    onMainImageChange (image) {
      if (image) {
        this.image = image
      }
    },
    onImageChange (image, elem) {
      console.log('*** onImageChange');
      console.log('* image');
      console.log(image);
      console.log('* elem');
      console.log(elem);

      this.uploadImageToBack(image, elem);
    },
    removeMainImage () {
      this.image = null;
    },
    removeImage (elem) {
      this.images[elem - 1] = null;
    },
    async uploadImageToBack(image, elem) {
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
        const image = result.data.createImage;

        this.images[elem - 1] = image;

        console.log(this.images);
      }
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
      grid-template-columns: repeat(3, 128px);
      grid-template-rows: repeat(2, 128px);
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
