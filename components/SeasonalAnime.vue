<template>
  <section
    class="grid gap-4 justify-items-center bg-sky-400/75 rounded-sm mt-2"
  >
    <article class="flex mt-2 gap-4 font-head">
      <div>
        <label for="year" class="font-bold text-white">Tahun</label>
        <input
          v-model="year"
          type="number"
          name="year"
          id="year"
          class="rounded py-1 placeholder:italic placeholder:text-gray-400 block bg-white w-full border text-gray-700 px-2 shadow focus:outline-none focus:border-teal-500 focus:ring-teal-500 focus:ring-1"
        />
      </div>

      <div>
        <label for="seasons" class="font-bold text-white">Season</label>
        <select
          v-model="season"
          name="seasons"
          id="seasons"
          class="rounded py-1 block bg-white w-full border text-gray-700 px-2 shadow focus:outline-none focus:border-teal-500 focus:ring-teal-500 focus:ring-1"
        >
          <option
            v-for="item in seasons"
            class="text-gray-700"
            :key="item.season"
            :value="item.season"
            :selected="item.season == season"
          >
            {{ toTitleCase(item.season) }}
          </option>
        </select>
      </div>

      <div>
        <label for="explicit" class="font-bold text-white"
          >Explicit Content</label
        >
        <div class="self-center">
          <input
            type="checkbox"
            name="explicit"
            id="explicit"
            class="h-4 w-4 border border-gray-300 rounded-sm bg-white checked:bg-blue-600 checked:border-blue-600 focus:outline-none transition duration-200 cursor-pointer"
            :checked="isAdult"
            v-model="isAdult"
          />
        </div>
      </div>

      <div>
        <button
          @click="filterSeasonalAnimes"
          class="transition px-4 py-2 bg-green-500 mt-5 rounded text-white hover:bg-green-600 ease-in-out duration-200 active:bg-green-700/90"
        >
          Filter
        </button>
      </div>
    </article>
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
      class="grid lg:grid-cols-3 gap-8 place-items-center font-body"
    >
      <AnimeCard
        v-for="anime in seasonalAnimes.media"
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
  name: 'SeasonalAnime',
  data() {
    return {
      seasonalAnimes: [],
      year: null,
      season: null,
      seasons: [
        { season: 'SPRING' },
        { season: 'SUMMER' },
        { season: 'FALL' },
        { season: 'WINTER' },
      ],
      isAdult: false,
      pageInfo: [],
      currentPage: 1,
    }
  },
  created() {
    const today = new Date()
    this.year = today.getFullYear()

    if (today.getMonth() >= 0 && today.getMonth() <= 2) {
      this.season = 'WINTER'
    } else if (today.getMonth() >= 3 && today.getMonth() <= 5) {
      this.season = 'SPRING'
    } else if (today.getMonth() >= 6 && today.getMonth() <= 8) {
      this.season = 'SUMMER'
    } else if (today.getMonth() >= 9 && today.getMonth() <= 11) {
      this.season = 'FALL'
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
    filterSeasonalAnimes: function () {
      if (this.year && this.season) {
        this.currentPage = 1

        if (this.year < 1940) {
          const today = new Date()
          this.year = today.getFullYear()
        }

        this.$fetch()
      }
    },
    toTitleCase: (word) => {
      word = word
        .toLowerCase()
        .split(' ')
        .map((item) => {
          return item.charAt(0).toUpperCase() + item.slice(1)
        })

      return word.join(' ')
    },
    getSeasonalAnimes: function () {
      const query = `
        query($page: Int, $perPage: Int, $season: MediaSeason, $seasonYear: Int, $type: MediaType, $isAdult: Boolean) {
            Page(page: $page, perPage: $perPage) {
                pageInfo {
                currentPage
                lastPage
                hasNextPage
                }
                media(season: $season, seasonYear: $seasonYear, type: $type, isAdult: $isAdult) {
                id
                idMal
                title {
                    english
                    romaji
                }
                coverImage {
                    large
                }
                isAdult
                }
            }
        }
      `

      let variable = {
        page: this.currentPage,
        perPage: 9,
        season: this.season,
        seasonYear: this.year,
        type: 'ANIME',
        isAdult: false,
      }

      if (this.isAdult == true) {
        delete variable['isAdult']
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
    this.seasonalAnimes = await this.getSeasonalAnimes()
    this.pageInfo = await this.seasonalAnimes.pageInfo
  },
}
</script>

<style lang="postcss" scoped></style>
