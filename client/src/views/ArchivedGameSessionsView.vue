<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import type { GameSession } from '../types/gameSession';
import { fetchArchivedGameSessions } from '../services/gameSessionService';
import GameSessionsList from '../components/organisms/GameSessionsList.vue';
import { ArrowLeftIcon } from '@heroicons/vue/24/outline';

const router = useRouter();
const gameSessions = ref<GameSession[]>([]);
const isLoading = ref(true);

const loadGameSessions = async () => {
  isLoading.value = true;
  try {
    gameSessions.value = await fetchArchivedGameSessions();
  } catch (error) {
    console.error('Error loading past sessions:', error);
  } finally {
    isLoading.value = false;
  }
};

const goBack = () => {
  router.push('/');
};

onMounted(loadGameSessions);
</script>

<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-purple-900 p-6">
    <div class="max-w-4xl mx-auto">
      <div class="flex items-center gap-4 mb-8">
        <button
            @click="goBack"
            class="p-2 rounded-full bg-gray-800 hover:bg-gray-700 transition-colors"
        >
          <ArrowLeftIcon class="h-6 w-6 text-white" />
        </button>
        <h1 class="text-3xl font-bold text-white">
          Past Game Sessions
        </h1>
      </div>

      <div v-if="isLoading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-purple-500 border-t-transparent"></div>
        <p class="text-white mt-4">Loading sessions...</p>
      </div>

      <GameSessionsList
          v-else
          :game-sessions="gameSessions"
      />
    </div>
  </div>
</template>