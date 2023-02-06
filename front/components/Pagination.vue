<template>
  <div
    v-if="options && totalItems > 0"
    class="pagination flex-fill"
  >
    <v-pagination
      v-model="options.page"
      :length="getTotalPages()"
      :total-visible="totalVisible || 7"
      prev-icon="fa-small-arrow-left"
      next-icon="fa-small-arrow-right"
      @input="setPage"
    />
    <span
      v-if="rowsPerPageItems"
      class="d-flex pl-2"
      style="position: relative;"
    >
      <v-select
        :items="rowsPerPageItems"
        :value="options.itemsPerPage"
        append-icon="fa-small-arrow-right"
        hide-details
        outlined
        height="32"
        style="width: 135px"
        @input="setRows"
      />
    </span>
    <span class="px-3">{{ $t('Components.Pagination["go-to"]') }}</span>
    <span>
      <v-text-field
        v-model="number"
        v-mask="'#######'"
        hide-details
        outlined
        style="width: 55px"
        @keypress.enter="setPage(number)"
      />
    </span>
  </div>
</template>

<script>
// import { mapGetters } from 'vuex'

export default {
  name: 'PaginationList',
  props: {
    pagination: {
      type: Object,
      default: () => {}
    },
    totalItems: {
      type: Number,
      default: () => 0
    },
    totalVisible: {
      type: [Number, Boolean],
      default: () => 7
    }
  },
  data () {
    return {
      loading: false,
      rowsPerPageItems: null,
      options: null,
      select: false,
      number: ''
    }
  },
}
</script>

<style lang="scss" scoped>
.pagination {
  display: flex;
  align-items: center;
  justify-content: flex-end;
  margin-top: 20px;

  ::v-deep {
    .v-pagination {
      li {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 22px;

        button {
          background-color: transparent !important;
          box-shadow: none !important;
          font-size: 18px;
          min-width: 22px;
          margin: 0;

          i {
            font-size: 18px;
          }
        }
        .v-pagination__more {
          margin: 0;
          font-size: 18px;
          height: unset;
        }
      }
      .v-pagination__item--active {
        color: var(--element-2);
      }
    }
    .v-input {
      .v-input__control {
        .v-input__slot {
          min-height: 30px !important;
        }
      }
    }
    .v-select {
      .v-input__control {
        .v-input__slot {
          padding-right: 4px;
        }
      }
    }
  }
}
</style>
