<script setup lang="ts">
import { computed } from 'vue';
import type { Playlist } from '../../types/playlist';
import PlaylistCard from '../molecules/PlaylistCard.vue';
import CollapsibleSection from '../molecules/CollapsibleSection.vue';

const props = defineProps<{
  playlists: Playlist[];
}>();

const notPlayedPlaylists = computed(() => 
  props.playlists.filter(p => !p.played)
);

const playedPlaylists = computed(() => 
  props.playlists.filter(p => p.played)
);
</script>

<template>
  <div class="space-y-6">
    <CollapsibleSection 
      title="Not Played" 
      :count="notPlayedPlaylists.length"
      :defaultOpen="true"
    >
      <PlaylistCard
          v-for="playlist in notPlayedPlaylists"
          :key="playlist.id"
          :playlist="playlist"
      />
      
      <div v-if="notPlayedPlaylists.length === 0" class="text-center py-8 text-gray-500">
        No playlists to play
      </div>
    </CollapsibleSection>
    
    <CollapsibleSection 
      title="Played" 
      :count="playedPlaylists.length"
      :defaultOpen="false"
    >
      <PlaylistCard
          v-for="playlist in playedPlaylists"
          :key="playlist.id"
          :playlist="playlist"
      />
      
      <div v-if="playedPlaylists.length === 0" class="text-center py-8 text-gray-500">
        No played playlists yet
      </div>
    </CollapsibleSection>
  </div>
</template>