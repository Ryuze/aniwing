<template>
  <article class="w-4/5" :class="anime.isAdult ? 'border-2 border-red-600' : ''">
    <NuxtLink :to="{ name: 'animes-slug', params: { slug: anime.id } }">
      <div
        class="grid justify-items-center bg-white rounded w-full h-full px-2 py-2"
      >
        <img
          :src="anime.coverImage.large"
          alt="cover image"
          class="rounded-sm"
        />
        <p class="mt-2 font-bold text-gray-800 text-center">
          {{ anime.title.english ? anime.title.english : anime.title.romaji }}
        </p>
        <p class="font-light text-sm text-gray-800 text-center">
          ( {{ anime.title.romaji }} )
        </p>
      </div>
    </NuxtLink>
  </article>
</template>

<script>
export default {
  props: {
    anime: Object,
  },
}
</script>

<style lang="postcss" scoped></style>
