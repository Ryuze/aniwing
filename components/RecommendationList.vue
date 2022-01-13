<template>
  <div class="grid lg:grid-cols-5 gap-2 place-items-center">
    <div class="col-span-5">
      <p class="text-lg font-bold text-gray-800">
        Rekomendasi acak untuk anda kali ini!
      </p>
    </div>
    <section v-for="anime in animeRecommendations" :key="anime.id">
      <div class="grid justify-center">
        <img
          :src="anime.media.coverImage.large"
          alt="cover"
          class="rounded justify-self-center"
        />
        <p
          class="justify-self-center mt-2 font-medium text-gray-800 text-center"
        >
          {{
            anime.media.title.english
              ? anime.media.title.english
              : anime.media.title.romaji
          }}
        </p>
        <p
          class="justify-self-center font-light text-sm text-gray-800 text-center"
        >
          ( {{ anime.media.title.romaji }} )
        </p>
      </div>
    </section>
  </div>
</template>

<script>
export default {
  name: 'RecommendationList',
  props: {
    animeRecommendations: Array,
  },
}
</script>

<style lang="postcss" scoped></style>
