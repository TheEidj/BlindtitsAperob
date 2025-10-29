
<script setup lang="ts">
import {ref, onMounted, nextTick} from 'vue';
import type { GameSession } from '../types/gameSession';
import { fetchUpcomingGameSession, registerTeam } from '../services/gameSessionService';
import UpcomingGameSessionCard from '../components/molecules/UpcomingGameSessionCard.vue';
import { useRouter } from 'vue-router';
import { animate } from 'animejs';

const router = useRouter();
const upcomingSession = ref<GameSession | null>(null);
const isLoading = ref(true);

const loadUpcomingSession = async () => {
  isLoading.value = true;
  try {
    upcomingSession.value = await fetchUpcomingGameSession();

    if (upcomingSession.value) {
      await nextTick()
      animate(
          '.upcoming-card',
          {
            opacity: [0, 1],
            translateY: [-50, 0],
            duration: 1000,
            easing: 'ease-out-cubic'
          }
      );
    }
  } catch (error) {
    console.error('Error loading upcoming session:', error);
  } finally {
    isLoading.value = false;
  }
};

const handleRegister = async (teamName: string, playerCount: number) => {
  if (!upcomingSession.value) return;

  try {
    await registerTeam(upcomingSession.value.id, teamName, playerCount);
    // Recharger la session pour afficher la nouvelle team
    await loadUpcomingSession();
  } catch (error) {
    console.error('Error registering team:', error);
  }
};

const navigateToOldSessions = () => {
  animate(
      '.landing-container',
      {
        opacity: [1, 0],
        translateX: [0, -100],
        duration: 400,
        easing: 'ease-in-cubic',
        complete: () => {
          router.push('/old-game-sessions');
        }
      }
  );
};

onMounted(() => {
  loadUpcomingSession();

  animate(
      '.hero-title',
      {
        opacity: [0, 1],
        translateY: [-30, 0],
        duration: 800,
        delay: 200,
        easing: 'ease-out-cubic'
      }
  );
});
</script>

<template>
  <div class="landing-container min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-indigo-900 flex flex-col">
    <div class="flex-1 max-w-4xl mx-auto w-full p-6 pt-12">
      <h1 class="hero-title text-5xl font-extrabold text-white text-center mb-12 opacity-0">
        Blindtits & Aperob
      </h1>

      <div v-if="isLoading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-indigo-500 border-t-transparent"></div>
        <p class="text-white mt-4">Loading...</p>
      </div>

      <div v-else-if="upcomingSession" class="upcoming-card mb-8 opacity-0">
        <UpcomingGameSessionCard
            :game-session="upcomingSession"
            @register="handleRegister"
        />
      </div>

      <div v-else class="bg-gray-800 rounded-2xl p-8 text-center mb-8">
        <p class="text-white text-xl mb-2">🔮 No upcoming game sessions</p>
        <p class="text-gray-400">Check back soon for the next event!</p>
      </div>

      <div class="text-center">
        <button
            @click="navigateToOldSessions"
            class="bg-gradient-to-r from-purple-600 to-indigo-600 text-white px-8 py-4 rounded-full font-bold text-lg hover:from-purple-700 hover:to-indigo-700 transition-all duration-300 shadow-lg hover:shadow-2xl transform hover:-translate-y-1"
        >
          View Past Game Sessions
        </button>
      </div>
    </div>
  </div>
</template>