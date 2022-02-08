<template>
  <main class="relative">
    <header>
      <NavsHeader />
    </header>
    <section class="container mx-auto mt-24 grid">
      <Nuxt />
    </section>
    <footer>
      <NavsFooter />
    </footer>
  </main>
</template>

<script>
export default {}
</script>

<style lang="postcss">
.font-head {
  font-family: 'Gelasio', serif;
}
.font-body {
  font-family: 'Signika Negative', sans-serif;
}
</style>
