<template>
  <div class="fixed block top-0 left-0 right-0 bg-sky-400 py-5 text-gray-100 z-50">
    <div class="container mx-auto grid grid-cols-2 justify-between">
      <div class="ml-2 self-center font-head">
        <nuxt-link to="/">AniWing</nuxt-link>
      </div>
      <div class="mr-2 justify-self-end grid grid-cols-2 gap-0">
        <div class="py-2 px-2 justify-self-end">
          <font-awesome-icon :icon="['fas', 'search']" />
        </div>
        <input
          class="rounded py-1 placeholder:italic placeholder:text-gray-400 block bg-white w-full border text-gray-700 px-2 shadow focus:outline-none focus:border-teal-500 focus:ring-teal-500 focus:ring-1"
          type="text"
          name="search"
          id="search"
          placeholder="Search here..."
        />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NavHeader',
}
</script>

<style lang="postcss" scoped></style>
