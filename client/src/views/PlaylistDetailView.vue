<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import type { Playlist } from '../types/playlist';
import { fetchPlaylistDetail, togglePlaylistPlayed, fetchPlaylistOembed } from '../services/playlistService';
import PlayedCheckbox from '../components/atoms/PlayedCheckbox.vue';
import PlaylistBadge from '../components/atoms/PlaylistBadge.vue';
import { ArrowLeftIcon } from '@heroicons/vue/24/outline';

const route = useRoute();
const router = useRouter();

const playlist = ref<Playlist | null>(null);
const isLoading = ref(true);
const embedHtml = ref<string>('');
const isLoadingEmbed = ref(false);

const loadPlaylist = async () => {
  try {
    const id = Number(route.params.id);
    playlist.value = await fetchPlaylistDetail(id);
    if (playlist.value) {
      await loadEmbed(id);
    }
  } catch (error) {
    console.error('Error loading playlist:', error);
  } finally {
    isLoading.value = false;
  }
};

const loadEmbed = async (playlistId: number) => {
  isLoadingEmbed.value = true;
  try {
    const data = await fetchPlaylistOembed(playlistId);

    if (data.html) {
      embedHtml.value = data.html;
    }
  } catch (error) {
    console.error('Error loading Deezer embed:', error);
  } finally {
    isLoadingEmbed.value = false;
  }
};

const handleTogglePlayed = async () => {
  if (!playlist.value) return;

  try {
    playlist.value = await togglePlaylistPlayed(playlist.value.id);
  } catch (error) {
    console.error('Error toggling played status:', error);
  }
};

const goBack = () => {
  router.push('/playlists');
};

onMounted(loadPlaylist);
</script>

<template>
  <div class="max-w-3xl mx-auto p-6">
    <button
        @click="goBack"
        class="mb-6 flex items-center gap-2 text-gray-400 hover:text-white transition"
    >
      <ArrowLeftIcon class="h-5 w-5" />
      Back to playlists
    </button>

    <div v-if="isLoading" class="text-center py-8 text-gray-400">
      Loading playlist...
    </div>

    <div v-else-if="playlist" class="space-y-6">
      <div class="bg-gray-800 border border-gray-700 rounded-lg p-6">
        <div class="flex items-start justify-between mb-4">
          <div>
            <h1 class="text-3xl font-bold mb-2">{{ playlist.name }}</h1>
            <PlaylistBadge
                :isMine="playlist.is_mine"
                :isFollowed="playlist.is_followed"
                :nbTrack="playlist.nbTrack"
                :isCollaborative="playlist.is_collaborative"
            />
          </div>
        </div>

        <div class="flex items-center gap-4 pt-4 border-t border-gray-700">
          <PlayedCheckbox
              :played="playlist.played"
              @toggle="handleTogglePlayed"
          />

          <a
              :href="playlist.url"
              target="_blank"
              class="px-4 py-2 bg-indigo-600 rounded-lg hover:bg-indigo-700 transition"
          >
            Open in Deezer
          </a>
        </div>
      </div>

      <!-- Deezer embed -->
      <div v-if="isLoadingEmbed" class="text-center py-8 text-gray-400">
        Loading player...
      </div>

      <div v-else-if="embedHtml" class="bg-gray-800 border border-gray-700 rounded-lg overflow-hidden">
        <div v-html="embedHtml"></div>
      </div>
    </div>
  </div>
</template>