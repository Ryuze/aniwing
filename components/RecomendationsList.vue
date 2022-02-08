<template>
  <section class="grid grid-cols-1 lg:grid-cols-5 gap-4 place-items-center">
    <article class="lg:col-span-5">
      <p class="text-lg font-bold text-gray-800 text-center font-head">
        Rekomendasi acak untuk anda kali ini!
      </p>
    </article>
    <section v-for="anime in animesRecommendation" :key="anime.media.id">
      <NuxtLink :to="{ name: 'animes-slug', params: { slug: anime.media.id } }">
        <article class="grid justify-center font-body">
          <img
            :src="anime.media.coverImage.large"
            alt="cover"
            class="rounded justify-self-center"
          />
          <p
            class="justify-self-center mt-2 font-bold text-gray-800 text-center"
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
        </article>
      </NuxtLink>
    </section>
  </section>
</template>

<script>
export default {
  props: {
    animesRecommendation: Array,
  },
}
</script>

<style lang="postcss" scoped></style>
