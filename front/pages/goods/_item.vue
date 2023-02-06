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
              <h1>{{ item.title }}</h1>
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
                    v-if="photos && photos.length"
                    class="gallery-small"
                  >
                    <div
                      v-for="(image, index) in photos"
                      :key="index"
                      :class="{ active: index === activePhotoIndex }"
                      :src="image?.dataUrl"
                      :style="`background-image: url(${image})`"
                      alt="PHOTO"
                      class="gallery-small-image"
                      @click="setActivePhoto(index)"
                    />
                  </div>
                </perfect-scrollbar>
                <div
                  class="main-image"
                  :style="`background-image: url(${getActivePhotoUrl})`"
                  alt="MAIN PHOTO"
                />
              </aside>
            </v-col>
            <v-col
              cols="12"
              md="6"
              class="pt-9"
            >
              <h2 class="mb-2">Краткое описание</h2>
              <p>{{ item.caption }}</p>

              <h2 class="mt-8 mb-3">Стоимость</h2>
              <v-simple-table
                height="100px"
              >
                <template v-slot:default>
                  <thead>
                    <tr>
                      <th
                        v-for="interval in item.intervals"
                        :key="interval.order"
                        class="text-left"
                      >
                        {{ interval.from }} - {{ interval.to }} шт
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td
                        v-for="interval in item.intervals"
                        :key="interval.order"
                      >
                        {{ interval.price }} ₽
                      </td>
                    </tr>
                  </tbody>
                </template>
              </v-simple-table>
              <p class="mt-3">
                <v-btn
                  color="primary"
                  depressed
                  small
                  tile
                  style="text-transform: none; letter-spacing: normal;"
                >
                  Предложить свою цену
                </v-btn>
              </p>
            </v-col>
          </v-row>
          <v-row>
            <v-col>
              <h2 class="mb-2 text-center">Информация о товаре</h2>
              <p>{{ item.description }}</p>
            </v-col>
          </v-row>
        </v-card>
      </v-col>

      <v-col
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
              Для определения стоимости продукта, условий или других запросов:
            </p>
            <p class="text-center">
              <NuxtLink
                to="/"
                style="text-decoration: none; font-size: 12px; line-height: 16px;"
              >
                Чат с продавцом
              </NuxtLink>
            </p>
          </v-card-text>
          <v-card-actions>
            <v-btn
              color="headerOrange"
              depressed
              style="letter-spacing: normal; width: 100%; color: #FFFFFF; font-weight: 700; font-size: 14px; line-height: 17px; padding: 20px;"
            >
              Добавить в корзину
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { PerfectScrollbar } from 'vue2-perfect-scrollbar'

export default {
  name: 'ItemPage',
  components: {
    PerfectScrollbar,
  },
  data () {
    return {
      loading: false,
      activePhoto: '',
      activePhotoIndex: 0,
      breadcrumbs: [
        {
          text: 'Электроника',
          disabled: false,
          href: '/',
        },
        {
          text: 'Бытовая электроника',
          disabled: false,
          href: '/',
        },
        {
          text: 'Утюги',
          disabled: false,
          href: '/',
        },
        {
          text: 'Паровой утюг Braun TexStyle 7 SI7088GY',
          disabled: true,
          href: '/',
        },
      ],
      item: {
        title: 'Кофемашина Philips 1220 series, черная',
        caption: '2 вкусных вида кофе из свежемолотых зерен — это легко! Наслаждайтесь великолепным вкусом и ароматом кофе из свежемолотых зерен, приготовленного при идеальной температуре с помощью нашей интеллектуальной системы заваривания. Классический капучинатор позволит вам легко сделать вкуснейший капучино или латте маккиато.',
        description: '2 вкусных вида кофе из свежемолотых зерен — это легко! Наслаждайтесь великолепным вкусом и ароматом кофе из свежемолотых зерен, приготовленного при идеальной температуре с помощью нашей интеллектуальной системы заваривания. Классический капучинатор позволит вам легко сделать вкуснейший капучино или латте маккиато. Классический капучинатор для великолепной молочной пенки. Настраивайте интенсивность аромата и объем порции кофе с помощью меню My Coffee Choice. Легко выбирайте любимый кофе с помощью простой сенсорной панели управления. Выбирайте нужный помол с помощью 12-уровневой регулировки положения жерновов. 20 000 чашек изысканного кофе с прочными керамическими жерновами. Идеальная температура и аромат, которым трудно противостоять. Полностью съемная варочная группа для удобной очистки. До 5000 чашек без очистки от накипи благодаря фильтру AquaClean. Автоматическое удаление налета для удобства использования. Простая очистка деталей в посудомоечной машине. Просто зарегистрируйте продукт в Клубе Philips в течение 90 дней со дня покупки и получите расширенную гарантию.С подробными условиями акции вы можете ознакомится на официальном сайте Philips. Для продления срока службы и сохранения вкусовых качеств напитков рекомендуются к использованию следующие аксессуары Philips: CA6700/10, CA6704/10, CA6903/10.',
        image: 'https://www.shop.philips.ru/media/catalog/product/cache/23/thumbnail/600x600/163b81649b7ef7bc8a00b0066e59ae0a/e/p/ep1220_00_image_01.jpg',
        images: [
          'https://www.shop.philips.ru/media/catalog/product/cache/23/thumbnail/600x600/163b81649b7ef7bc8a00b0066e59ae0a/e/p/ep1220_00_image_02.jpg',
          'https://www.shop.philips.ru/media/catalog/product/cache/23/thumbnail/600x600/163b81649b7ef7bc8a00b0066e59ae0a/e/p/ep1220_00_image_03.jpg',
          'https://www.shop.philips.ru/media/catalog/product/cache/23/thumbnail/600x600/163b81649b7ef7bc8a00b0066e59ae0a/e/p/ep1220_00_image_04.jpg',
          'https://www.shop.philips.ru/media/catalog/product/cache/23/thumbnail/600x600/163b81649b7ef7bc8a00b0066e59ae0a/e/p/ep1220_00_image_06.jpg',
          'https://www.shop.philips.ru/media/catalog/product/cache/23/thumbnail/600x600/163b81649b7ef7bc8a00b0066e59ae0a/e/p/ep1220_00_image_07.jpg',
          'https://www.shop.philips.ru/media/catalog/product/cache/23/thumbnail/600x600/163b81649b7ef7bc8a00b0066e59ae0a/e/p/ep1220_00_image_08.jpg'
        ],
        category1: 'Бытовая техника',
        category2: 'Техника для кухни',
        category3: 'Кофеварки и кофемашины',
        intervals: [
          {
            order: 1,
            from: 1,
            to: 499,
            price: 34990,
            unit: 'piece'
          },
          {
            order: 2,
            from: 500,
            to: 999,
            price: 34490,
            unit: 'piece'
          },
          {
            order: 3,
            from: 1000,
            to: 9999,
            price: 32990,
            unit: 'piece'
          }
        ]
      }
    }
  },
  computed: {
    photos () {
      return [ this.item.image, ...this.item.images || [] ];
    },
    getActivePhotoUrl () {
      return this.activePhoto;
    }
  },
  beforeCreate() {
    console.log('**')

    const itemId = this.$route.params.item

    console.log('itemId', itemId)
  },
  mounted () {
    this.activePhoto = this.item.image;
  },
  methods: {
    setActivePhoto(index) {
      this.activePhoto = this.photos[index];
      this.activePhotoIndex = index;
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
      margin-left: 16px;
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
