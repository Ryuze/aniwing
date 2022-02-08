<template>
  <section>
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
      <p class="text-red-600 text-lg font-bold">
        Something went wrong while getting data information, please contact our
        admin.
      </p>
    </article>
    <section v-else>
      <article>
        <RecomendationsList :animesRecommendation="AnimesRecomendation" />
      </article>
      <article>
        <SeasonalAnime />
      </article>
    </section>
  </section>
</template>

<script>
export default {
  name: 'IndexPage',
  layout: 'mainLayout',
  data() {
    return {
      AnimesRecomendation: [],
    }
  },
  methods: {
    getAnimesRecomendation: function () {
      const query = `
        query($page: Int, $perPage: Int, $rating: Int) {
          Page(page: $page, perPage: $perPage) {
            recommendations(rating_greater: $rating, sort: RATING) {
              id
              rating
              media {
                title {
                  romaji
                  english
                }
                coverImage {
                  large
                }
              }
            }
          }
        }
      `

      const variable = {
        page: 1,
        perPage: 5,
        rating: Math.floor(Math.random() * 99) + 1,
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
      }).then((response) => response.data.data.Page.recommendations)
    },
  },
  async fetch() {
    this.AnimesRecomendation = await this.getAnimesRecomendation()
  },
}
</script>
