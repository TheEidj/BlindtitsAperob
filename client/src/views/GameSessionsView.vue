<script setup lang="ts">
import {ref, onMounted} from 'vue';
import type { GameSession } from '../types/gameSession';
import { fetchAllGameSessions } from '../services/gameSessionService';
import BaseModal from "../components/atoms/BaseModal.vue";
import GameSessionsList from '../components/organisms/GameSessionsList.vue';
import GameSessionForm from '../components/organisms/GameSessionForm.vue';
import LoadingSpinner from '../components/atoms/LoadingSpinner.vue';
import { PlusIcon } from '@heroicons/vue/24/solid';
import { animate } from 'animejs';

const gameSessions = ref<GameSession[]>([]);
const isLoading = ref(true);
const showCreateModal = ref(false);


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
  <h1 class="text-3xl font-bold text-white mb-8">Game Sessions</h1>

  <!-- Floating Add Button -->
  <button
      @click="showCreateModal = true"
      class="add-button fixed bottom-24 right-6 bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-4 rounded-full shadow-2xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-300 z-40"
  >
    <PlusIcon class="h-8 w-8" />
  </button>

  <BaseModal
      title="Create New Game Session"
      :show="showCreateModal"
      @close="showCreateModal = false">
    <template #content>
      <GameSessionForm
          mode="create"
          @done="() => { showCreateModal = false; loadGameSessions() }"
      />
    </template>
  </BaseModal>

  <LoadingSpinner v-if="isLoading" />

  <GameSessionsList
      v-else
      :game-sessions="gameSessions"
  />
</template>