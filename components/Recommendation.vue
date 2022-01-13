<template>
  <div class="relative grid">
    <div class="justify-self-center" v-show="loading">
      <font-awesome-icon
        :icon="['fas', 'spinner']"
        class="animate-spin text-gray-300"
        style="width: 4em; height: 4em"
      />
    </div>
    <section class="justify-self-center" v-if="isError">
      <p class="text-red-600 text-lg shadow-sm">
        Something went wrong with the data when trying to load todays popular,
        please contact our admin.
      </p>
    </section>
    <section class="justify-self-center" v-show="!loading && !isError">
      <RecommendationList :animeRecommendations="animeRecommendations" />
    </section>
  </div>
</template>

<script>
import RecommendationList from './RecommendationList.vue'
export default {
  components: { RecommendationList },
  name: 'Recommendation',
  data() {
    return {
      animeRecommendations: null,
      loading: true,
      isError: false,
    }
  },
  mounted() {
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

    this.$axios({
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
    })
      .then((response) => {
        this.animeRecommendations = response.data.data.Page.recommendations
      })
      .catch((error) => {
        console.log(error)
        this.isError = true
      })
      .finally(() => (this.loading = false))
  },
}
</script>

<style lang="postcss" scoped></style>
