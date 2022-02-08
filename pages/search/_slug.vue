<template>
  <section
    class="grid gap-4 justify-items-center bg-sky-400/75 rounded-sm mt-2"
  >
    <article
      v-if="$fetchState.pending"
      class="h-screen grid place-items-center"
    >
      <font-awesome-icon
        :icon="['fas', 'spinner']"
        class="animate-spin text-white"
        style="width: 4em; height: 4em"
      />
    </article>
    <article
      v-else-if="$fetchState.error"
      class="h-screen grid place-items-center font-body"
    >
      <p class="text-red-600 text-lg shadow-sm">
        Something went wrong while getting data information, please contact our
        admin.
      </p>
    </article>
    <section
      v-else
      class="grid lg:grid-cols-3 gap-8 place-items-center font-body mt-2"
    >
      <AnimeCard
        v-for="anime in listAnimes.media"
        :key="anime.id"
        :anime="anime"
      />
      <article
        class="grid grid-cols-2 lg:col-span-3 place-self-center gap-4 mb-2"
      >
        <div
          :class="!pageInfo.hasNextPage ? 'col-span-2' : ''"
          v-show="currentPage > 1"
        >
          <button @click="previousPage" class="bg-white rounded-3xl px-4 py-2">
            <font-awesome-icon
              :icon="['fas', 'angle-left']"
              class="text-gray-700"
            />
          </button>
        </div>
        <div
          :class="currentPage == 1 && pageInfo.hasNextPage ? 'col-span-2' : ''"
          v-show="pageInfo.hasNextPage"
        >
          <button @click="nextPage" class="bg-white rounded-3xl px-4 py-2">
            <font-awesome-icon
              :icon="['fas', 'angle-right']"
              class="text-gray-700"
            />
          </button>
        </div>
      </article>
    </section>
  </section>
</template>

<script>
export default {
  layout: 'mainLayout',
  async asyncData({ params }) {
    const slug = params.slug
    return { slug }
  },
  data() {
    return {
      listAnimes: [],
      pageInfo: [],
      currentPage: 1,
    }
  },
  methods: {
    nextPage: function () {
      if (this.pageInfo.hasNextPage) {
        this.currentPage += 1
        this.$fetch()
      }
    },
    previousPage: function () {
      if (this.currentPage >= 2) {
        this.currentPage -= 1
        this.$fetch()
      }
    },
    getListAnimes: function () {
      const query = `
        query($page: Int, $perPage: Int, $search: String, $type: MediaType) {
          Page(page: $page, perPage: $perPage) {
            pageInfo {
              currentPage
              lastPage
              hasNextPage
            }
            media(search: $search, type: $type) {
              id
              coverImage{
                large
              }
              title {
                english
                romaji
              }
              isAdult
            }
          }
        }
      `

      let variable = {
        page: this.currentPage,
        perPage: 9,
        search: this.slug,
        type: 'ANIME',
      }

      return this.$axios({
        url: 'https://graphql.anilist.co',
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
        },
        data: {
          query: query,
          variables: variable,
        },
      }).then((response) => response.data.data.Page)
    },
  },
  async fetch() {
    this.listAnimes = await this.getListAnimes()
    this.pageInfo = await this.listAnimes.pageInfo
  },
}
</script>

<style lang="postcss" scoped></style>
