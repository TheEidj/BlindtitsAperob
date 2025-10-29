<script setup lang="ts">
import {ref, onMounted, computed, nextTick} from 'vue';
import { useRouter } from 'vue-router';
import type { GameSession } from '../types/gameSession';
import { fetchAllGameSessions, createGameSession } from '../services/gameSessionService';
import GameSessionCard from '../components/molecules/GameSessionCard.vue';
import CollapsibleSection from '../components/molecules/CollapsibleSection.vue';
import { PlusIcon } from '@heroicons/vue/24/solid';
import { animate } from 'animejs';

const router = useRouter();
const gameSessions = ref<GameSession[]>([]);
const isLoading = ref(true);
const showCreateModal = ref(false);
const newSessionDate = ref('');

const upcomingSessions = computed(() =>
    gameSessions.value.filter(gs => gs.upcoming)
);

const pastSessions = computed(() =>
    gameSessions.value.filter(gs => !gs.upcoming)
);

const loadGameSessions = async () => {
  isLoading.value = true;
  try {
    gameSessions.value = await fetchAllGameSessions();
  } catch (error) {
    console.error('Error loading game sessions:', error);
  } finally {
    isLoading.value = false;
  }
};

const handleSessionClick = (sessionId: number) => {
  router.push(`/game-sessions/${sessionId}/admin`);
};

const openCreateModal = () => {
  showCreateModal.value = true;
  nextTick();
  animate(
      '.create-modal',
      {
        opacity: [0, 1],
        scale: [0.9, 1],
        duration: 400,
        easing: 'ease-out-cubic'
      }
  );
};

const handleCreateSession = async () => {
  if (!newSessionDate.value) return;

  try {
    await createGameSession(newSessionDate.value);
    await loadGameSessions();
    showCreateModal.value = false;
    newSessionDate.value = '';
  } catch (error) {
    console.error('Error creating game session:', error);
  }
};

onMounted(() => {
  loadGameSessions();

  animate(
      '.add-button',
      {
        scale: [0, 1],
        rotate: ['180deg', '0deg'],
        duration: 800,
        delay: 500,
        easing: 'ease-out-elastic'
      }
  );
});
</script>

<template>
  <div class="max-w-4xl mx-auto p-6 pb-24">
    <h1 class="text-3xl font-bold text-white mb-8">Game Sessions Management</h1>

    <div v-if="isLoading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-indigo-500 border-t-transparent"></div>
    </div>

    <div v-else class="space-y-6">
      <CollapsibleSection
          title="Upcoming Sessions"
          :count="upcomingSessions.length"
          :defaultOpen="true"
      >
        <div class="space-y-3">
          <GameSessionCard
              v-for="session in upcomingSessions"
              :key="session.id"
              :game-session="session"
              @click="handleSessionClick(session.id)"
          />
        </div>

        <div v-if="upcomingSessions.length === 0" class="text-center py-8 text-gray-500">
          No upcoming sessions
        </div>
      </CollapsibleSection>

      <CollapsibleSection
          title="Past Sessions"
          :count="pastSessions.length"
          :defaultOpen="false"
      >
        <div class="space-y-3">
          <GameSessionCard
              v-for="session in pastSessions"
              :key="session.id"
              :game-session="session"
              @click="handleSessionClick(session.id)"
          />
        </div>

        <div v-if="pastSessions.length === 0" class="text-center py-8 text-gray-500">
          No past sessions
        </div>
      </CollapsibleSection>
    </div>

    <!-- Floating Add Button -->
    <button
        @click="openCreateModal"
        class="add-button fixed bottom-24 right-6 bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-4 rounded-full shadow-2xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-300 z-40"
    >
      <PlusIcon class="h-8 w-8" />
    </button>

    <!-- Create Modal -->
    <div
        v-if="showCreateModal"
        class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4"
        @click.self="showCreateModal = false"
    >
      <div class="create-modal bg-gray-800 rounded-2xl p-6 max-w-md w-full">
        <h2 class="text-2xl font-bold text-white mb-4">Create New Game Session</h2>

        <div class="mb-4">
          <label class="block text-white font-medium mb-2">Scheduled Date & Time</label>
          <input
              v-model="newSessionDate"
              type="datetime-local"
              class="w-full px-4 py-3 rounded-lg bg-gray-700 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
        </div>

        <div class="flex gap-3">
          <button
              @click="showCreateModal = false"
              class="flex-1 px-6 py-3 bg-gray-700 text-white rounded-lg hover:bg-gray-600 transition-colors"
          >
            Cancel
          </button>
          <button
              @click="handleCreateSession"
              :disabled="!newSessionDate"
              class="flex-1 px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            Create
          </button>
        </div>
      </div>
    </div>
  </div>
</template>