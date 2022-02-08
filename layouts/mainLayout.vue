<template>
  <main class="relative">
    <header>
      <NavHeader />
    </header>
    <section class="container mx-auto mt-24 grid">
      <Nuxt />
    </section>
  </main>
</template>

<script>
import NavHeader from '~/components/NavHeader.vue'
export default {
  components: {
    NavHeader,
  },
}
</script>

<style lang="postcss">
.font-head {
  font-family: 'Gelasio', serif;
}
.font-body {
  font-family: 'Signika Negative', sans-serif;
}
</style>
