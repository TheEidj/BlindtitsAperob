<script setup lang="ts">
import { ref, onMounted } from "vue";
import type { Playlist } from "../types/playlist";
import PlaylistsList from "../components/organisms/PlaylistsList.vue";
import { fetchPlaylists, refreshPlaylists } from "../services/playlistService";
import { ArrowPathIcon } from "@heroicons/vue/24/outline"

const playlists = ref<Playlist[]>([]);
const isLoading = ref(false);
const isRefreshing = ref(false);
const toastMessage = ref<string | null>(null);
const toastTimeout = ref<number | null>(null);

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

const showToast = (message: string) => {
  if (toastTimeout.value) {
    clearTimeout(toastTimeout.value);
  }
  toastMessage.value = message;
  toastTimeout.value = window.setTimeout(() => {
    toastMessage.value = null;
  }, 3000);
};

const handleArchived = async (id: number) => {
  const playlist = playlists.value.find(p => p.id === id);
  if (playlist) {
    showToast(`${playlist.name} marked as done`);
  }
  // Recharger les playlists après archivage
  await loadPlaylists();
};

onMounted(loadPlaylists);
</script>

<template>
  <div class="flex justify-between items-center mb-6">
    <h1 class="text-3xl font-bold">Playlists</h1>
    <button
        @click="handleRefresh"
        :disabled="isRefreshing"
        class="btn primary"
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
      @archived="handleArchived"
  />

  <!-- Toast notification -->
  <Transition
      enter-active-class="transition ease-out duration-300"
      enter-from-class="translate-y-2 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transition ease-in duration-200"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="translate-y-2 opacity-0"
  >
    <div
        v-if="toastMessage"
        class="fixed bottom-30 w-full flex justify-center text-center z-50"
    >
      <div class="bg-green-600 text-white px-10 py-3 rounded-lg shadow-lg">
        {{ toastMessage }}
      </div>
    </div>
  </Transition>
</template>
