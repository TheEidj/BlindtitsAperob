<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import type { GameSession } from '../types/gameSession';
import { fetchGameSessionDetail } from '../services/gameSessionService';
import { ArrowLeftIcon, UserGroupIcon, MusicalNoteIcon } from '@heroicons/vue/24/outline';
import { animate } from 'animejs';

const route = useRoute();
const router = useRouter();
const gameSession = ref<GameSession | null>(null);
const isLoading = ref(true);

const loadGameSession = async () => {
  isLoading.value = true;
  try {
    const id = Number(route.params.id);
    gameSession.value = await fetchGameSessionDetail(id);

    animate({
      targets: '.detail-section',
      opacity: [0, 1],
      translateY: [20, 0],
      delay: anime.stagger(150),
      duration: 600,
      easing: 'easeOutCubic'
    });
  } catch (error) {
    console.error('Error loading game session:', error);
  } finally {
    isLoading.value = false;
  }
};

const formatDate = (dateString: string) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('fr-FR', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

const goBack = () => {
  router.back();
};

onMounted(loadGameSession);
</script>

<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-indigo-900 p-6">
    <div class="max-w-4xl mx-auto">
      <button
          @click="goBack"
          class="mb-6 p-2 rounded-full bg-gray-800 hover:bg-gray-700 transition-colors"
      >
        <ArrowLeftIcon class="h-6 w-6 text-white" />
      </button>

      <div v-if="isLoading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-indigo-500 border-t-transparent"></div>
      </div>

      <div v-else-if="gameSession" class="space-y-6">
        <div class="detail-section bg-gradient-to-r from-indigo-600 to-purple-600 rounded-2xl p-6 opacity-0">
          <h1 class="text-3xl font-bold text-white mb-2">Game Session</h1>
          <p class="text-white/90 text-lg">{{ formatDate(gameSession.date) }}</p>
        </div>

        <div class="detail-section bg-gray-800 rounded-xl p-6 opacity-0">
          <div class="flex items-center gap-3 mb-4">
            <UserGroupIcon class="h-6 w-6 text-indigo-400" />
            <h2 class="text-xl font-bold text-white">Teams</h2>
          </div>

          <div v-if="gameSession.teams && gameSession.teams.length > 0" class="space-y-3">
            <div
                v-for="team in gameSession.teams"
                :key="team.id"
                class="bg-gray-700 rounded-lg p-4 flex justify-between items-center"
                :style="{ borderLeft: `4px solid ${team.color}` }"
            >
              <span class="text-white font-medium">{{ team.name }}</span>
              <span class="text-gray-400">{{ team.player_count }} players</span>
            </div>
          </div>

          <div v-else class="text-gray-400 text-center py-4">
            No teams registered
          </div>
        </div>

        <div class="detail-section bg-gray-800 rounded-xl p-6 opacity-0">
          <div class="flex items-center gap-3 mb-4">
            <MusicalNoteIcon class="h-6 w-6 text-indigo-400" />
            <h2 class="text-xl font-bold text-white">Playlists</h2>
          </div>

          <div v-if="gameSession.playlists && gameSession.playlists.length > 0" class="space-y-3">
            <div
                v-for="playlist in gameSession.playlists"
                :key="playlist.id"
                class="bg-gray-700 rounded-lg p-4 flex items-center gap-4"
            >
              <img
                  v-if="playlist.picture_url"
                  :src="playlist.picture_url"
                  :alt="playlist.name"
                  class="w-16 h-16 rounded-lg object-cover"
              />
              <span class="text-white font-medium">{{ playlist.name }}</span>
            </div>
          </div>

          <div v-else class="text-gray-400 text-center py-4">
            No playlists added
          </div>
        </div>
      </div>
    </div>
  </div>
</template>