<template>
  <div class="label">
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
    }
  },
}
</script>

<style lang="scss" scoped>
  .label {
    min-width: 30px;
    width: fit-content;
    height: 26px;
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    padding: 8px 24px;
    font-style: normal;
    font-weight: 700;
    font-size: 14px;
    line-height: 14px;
    text-align: center;
    color: #FFFFFF;
    background: #B4CD0F;
    border-radius: 8px;
  }
</style>