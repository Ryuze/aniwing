<template>
  <section class="grid place-items-center bg-sky-400/75 pb-3">
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
        Something went wrong with the data when trying to load todays popular,
        please contact our admin.
      </p>
    </article>
    <section v-else class="grid place-items-center font-body">
      <article v-if="anime.data.Media.bannerImage" class="-mt-4">
        <img
          :src="anime.data.Media.bannerImage"
          alt="banner"
          class="w-screen"
        />
      </article>
      <article
        class="grid place-items-center bg-white w-3/4 rounded-2xl gap-2 shadow-md"
        :class="anime.data.Media.bannerImage ? '-mt-10 z-10' : 'mt-2'"
      >
        <p class="font-bold font-head text-gray-800 text-center mt-2 text-2xl">
          {{
            anime.data.Media.title.english
              ? anime.data.Media.title.english
              : anime.data.Media.title.romaji
          }}
        </p>
        <p class="font-light text-sm font-head text-gray-800 text-center">
          ({{ anime.data.Media.title.romaji }})
        </p>
        <div>
          <a :href="anime.data.Media.coverImage.extraLarge" target="_blank">
            <img
              :src="anime.data.Media.coverImage.large"
              alt="image"
              class="rounded-xl"
            />
          </a>
        </div>
        <div v-if="anime.data.Media.isAdult">
          <p class="text-red-600 font-bold text-2xl font-head text-center">
            WARNING: Anime mengandung unsur R-18
          </p>
        </div>
        <article
          class="grid lg:grid-rows-5 lg:grid-flow-col gap-x-6 gap-y-2 font-normal text-gray-800 w-4/5"
        >
          <div class="grid grid-cols-2 content-center">
            <p class="self-center leading-4">Judul native:</p>
            <p class="justify-self-end">{{ anime.data.Media.title.native }}</p>
          </div>
          <div class="grid grid-cols-2 content-center">
            <p class="self-center">Format anime:</p>
            <p class="justify-self-end">{{ anime.data.Media.format }}</p>
          </div>
          <div class="grid grid-cols-2 content-center">
            <p class="self-center">Tanggal tayang:</p>
            <p class="justify-self-end">
              {{ this.toDate(anime.data.Media.startDate) }}
            </p>
          </div>
          <div class="grid grid-cols-2 content-center">
            <p class="self-center">Tanggal selesai:</p>
            <p class="justify-self-end">
              {{
                anime.data.Media.endDate
                  ? this.toDate(anime.data.Media.endDate)
                  : '-'
              }}
            </p>
          </div>
          <div class="grid grid-cols-2 content-center">
            <p>Status:</p>
            <p class="justify-self-end">{{ anime.data.Media.status }}</p>
          </div>
          <div class="grid grid-cols-2 content-center">
            <p class="self-center">Genre:</p>
            <p class="justify-self-end leading-4">
              {{ anime.data.Media.genres.join(', ') }}
            </p>
          </div>
          <div class="grid grid-cols-2 content-center">
            <p class="self-center">Episode:</p>
            <p class="justify-self-end">{{ anime.data.Media.episodes }}</p>
          </div>
          <div class="grid grid-cols-2 content-center">
            <p class="self-center">Durasi per episode:</p>
            <p class="justify-self-end">
              {{ anime.data.Media.duration }} Menit
            </p>
          </div>
          <div class="grid grid-cols-2 content-center">
            <p class="self-center">MyAnimeList:</p>
            <a
              :href="'https://myanimelist.net/anime/' + anime.data.Media.idMal"
              class="px-2 py-1 rounded bg-blue-600 hover:bg-blue-700 transition-colors text-white justify-self-end"
              target="_blank"
              >Link</a
            >
          </div>
        </article>
        <article
          v-if="anime.data.Media.description"
          class="grid w-full text-gray-800 text-justify"
          :class="anime.data.Media.characters.edges.length == 0 ? 'mb-2' : ''"
        >
          <p class="font-head font-bold text-xl mx-2">Deskripsi</p>
          <p class="mx-2" v-html="anime.data.Media.description" />
        </article>
        <article
          v-if="!anime.data.Media.characters.edges.length == 0"
          class="grid w-full text-gray-800 text-justify mb-2"
        >
          <p class="font-head font-bold text-xl mx-2">Karakter</p>
          <div
            class="grid grid-cols-3 lg:grid-cols-6 justify-items-center gap-2 mx-2"
          >
            <div
              v-for="character in anime.data.Media.characters.edges"
              :key="character.edges"
              class="1/2"
            >
              <a :href="character.node.image.large" target="_blank">
                <img
                  :src="character.node.image.medium"
                  alt="character"
                  class="mx-auto h-40"
                />
              </a>
              <p class="font-bold text-center">
                {{ character.node.name.full }}
              </p>
              <p
                v-if="character.node.name.native"
                class="font-light text-center"
              >
                ({{ character.node.name.native }})
              </p>
              <p class="font-bold text-sm text-center">{{ character.role }}</p>
            </div>
          </div>
        </article>
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
      anime: [],
    }
  },
  methods: {
    toDate(date) {
      const { day, month, year } = date
      const newDate = new Date(year, month, day)
      return newDate.toLocaleDateString('id', {
        day: 'numeric',
        month: 'long',
        year: 'numeric',
      })
    },
  },
  async fetch() {
    const query = `
      query($id: Int) {
        Media(id: $id) {
          idMal
          coverImage {
            extraLarge
            large
          }
          bannerImage
          title {
            romaji
            english
            native
          }
          isAdult
          format
          status
          description
          genres
          characters(sort: ROLE) {
            edges {
              role
              node {
                name {
                  full
                  native
                }
                image {
                  large
                  medium
                }
              }
            }
          }
          season
          seasonYear
          startDate {
            year
            month
            day
          }
          endDate {
            year
            month
            day
          }
          episodes
          duration
        }
      }
    `

    let variable = {
      id: this.slug,
    }

    this.anime = await this.$axios({
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
    }).then((response) => response.data)
  },
}
</script>

<style lang="postcss" scoped></style>
