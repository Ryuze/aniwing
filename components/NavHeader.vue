<template>
  <div
    class="fixed block top-0 left-0 right-0 bg-sky-400 py-5 text-gray-100 z-50"
  >
    <div class="container mx-auto grid grid-cols-2 justify-between">
      <div class="ml-2 self-center font-head font-bold">
        <nuxt-link to="/">AniWing</nuxt-link>
      </div>
      <div class="mr-2 justify-self-end">
        <form
          method="post"
          @submit.prevent="searchAnime"
          class="grid grid-cols-2 gap-0"
        >
          <button type="submit" class="py-2 px-2 justify-self-end">
            <font-awesome-icon :icon="['fas', 'search']" />
          </button>
          <input
            class="rounded py-1 placeholder:italic placeholder:text-gray-400 block bg-white w-full border text-gray-700 px-2 shadow focus:outline-none focus:border-teal-500 focus:ring-teal-500 focus:ring-1"
            type="text"
            name="search"
            id="search"
            placeholder="Search here..."
            v-model.trim="search"
          />
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NavHeader',
  data() {
    return {
      search: null,
    }
  },
  methods: {
    searchAnime: function () {
      this.$router.push({ name: 'search-slug', params: { slug: this.search } })
    },
  },
}
</script>

<style lang="postcss" scoped></style>
