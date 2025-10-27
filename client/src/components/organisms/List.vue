<script setup lang="ts">
import type { Playlist } from "../../types/playlist";
import PlaylistCard from "../molecules/PlaylistCard.vue";

defineProps<{
  playlists: Playlist[]
}>();

</script>

<template>
  <div class="grid gap-4">
    <PlaylistCard
        v-for="(pl, i) in playlists"
        :key="pl.id"
        :playlist="pl"
        :index="i"
    />
  </div>
</template>
