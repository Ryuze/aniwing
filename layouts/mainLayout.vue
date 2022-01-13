<template>
  <div class="relative">
    <NavHeader />
    <div class="container mx-auto mt-24 grid">
      <Nuxt />
    </div>
  </div>
</template>

<script>
import NavHeader from '~/components/NavHeader.vue'
export default {
  components: {
    NavHeader,
  },
  data() {
    return {
      isScrolled: null,
    }
  },
}
</script>

<style lang="postcss" scoped></style>
