<script setup lang="ts">
import { ref, onMounted } from "vue";
import type { Playlist } from "../types/playlist";
import PlaylistsList from "../components/organisms/PlaylistsList.vue";
import { fetchPlaylists, refreshPlaylists, togglePlaylistPlayed } from "../services/playlistService";
import { ArrowPathIcon } from "@heroicons/vue/24/outline"

const playlists = ref<Playlist[]>([]);
const isLoading = ref(false);
const isRefreshing = ref(false);

const loadPlaylists = async () => {
  isLoading.value = true;
  try {
    playlists.value = await fetchPlaylists();
  } catch (error) {
    console.error('Error loading playlists:', error);
  } finally {
    isLoading.value = false;
  }
};

const handleRefresh = async () => {
  isRefreshing.value = true;
  try {
    playlists.value = await refreshPlaylists();
  } catch (error) {
    console.error('Error refreshing playlists:', error);
  } finally {
    isRefreshing.value = false;
  }
};

const handleTogglePlayed = async (playlistId: number) => {
  try {
    const updatedPlaylist = await togglePlaylistPlayed(playlistId);
    
    // Mettre à jour la playlist dans la liste
    const index = playlists.value.findIndex(p => p.id === playlistId);
    if (index !== -1) {
      playlists.value[index] = updatedPlaylist;
    }
  } catch (error) {
    console.error('Error toggling playlist played status:', error);
  }
};

onMounted(loadPlaylists);
</script>

<template>
  <div class="max-w-3xl mx-auto p-6">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold">Playlists</h1>
      <button
          @click="handleRefresh"
          :disabled="isRefreshing"
          class="px-4 py-2 bg-indigo-600 rounded-lg hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed transition flex items-center gap-2"
      >
        <ArrowPathIcon
            v-if="isRefreshing"
            class="h-5 w-5 animate-spin"
        />
        {{ isRefreshing ? 'Refreshing...' : 'Refresh from Deezer' }}
      </button>
    </div>

    <div v-if="isLoading" class="text-center py-8 text-gray-400">
      Loading playlists...
    </div>
    
    <PlaylistsList 
      v-else 
      :playlists="playlists" 
      @toggle-played="handleTogglePlayed"
    />
  </div>
</template>
