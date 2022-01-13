<template>
  <div>
    <Recommendation />
    <button @click="show = !show">Click me</button>
    <!-- TODO: tambah data season musim ini -->
  </div>
</template>

<script>
import Recommendation from '~/components/Recommendation.vue'
export default {
  components: { Recommendation },
  name: 'IndexPage',
  layout: 'mainLayout',
  data() {
    return {
      show: true,
    }
  },
  methods: {
    async anilist() {
      try {
        const query = `
        query($page: Int, $perPage: Int, $trending: Int) {
          Page(page: $page, perPage: $perPage) {
            pageInfo {
              total
              perPage
              currentPage
              lastPage
              hasNextPage
            }
            mediaTrends(trending: $trending) {
              mediaId
              media {
                title {
                  romaji
                  english
                  native
                }
                description
                status
                episodes
                genres
              }
              trending
            }
          }
        }
        `

        const variable = {
          page: 1,
          perPage: 5,
          trending: 1,
        }

        let response = await this.$axios({
          url: 'https://graphql.anilist.co',
          method: 'POST',
          data: {
            query: query,
            variables: variable,
          },
        })

        console.log(response)
      } catch (err) {
        console.log(err)
      }
    },
  },
}
</script>
