<template>
  <div
    class="label"
    :style="`background-color: ${backgroundColor}`"
  >
    {{ value }}
  </div>
</template>

<script>
export default {
  name: 'Label',
  props: {
    value: {
      type: String,
      required: true
    },
    color: {
      type: String,
      default: '#272727'
    }
  },
  computed: {
    backgroundColor () {
      switch (this.color) {
        case 'purple':
          return '#885AF8';
        case 'yellow':
          return '#FFC300';
        case 'orange':
          return '#FF9B00';
        case 'green':
          return '#B4CD0F';
        case 'grey':
          return '#BDBDBD';
        case 'teal':
          return '#47b8d1';
        default:
          return '#272727';
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  .label {
    min-width: 30px;
    display: inline-block;
    padding: 4px 12px;
    font-style: normal;
    font-weight: 700;
    font-size: 12px;
    line-height: 14px;
    text-align: center;
    color: #fafafa;
    border-radius: 8px !important;
    white-space: nowrap;
  }
</style>