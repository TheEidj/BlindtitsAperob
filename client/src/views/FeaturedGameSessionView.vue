<script setup lang="ts">
import {computed, nextTick, onMounted, ref} from 'vue';
import type { GameSession } from '../types/gameSession.ts';
import {CalendarIcon, MicrophoneIcon, MusicalNoteIcon, UserGroupIcon} from '@heroicons/vue/24/outline';
import { animate } from 'animejs';
import TeamForm from "../components/organisms/TeamForm.vue";
import {fetchFeaturedGameSession} from "../services/gameSessionService.ts";
import LoadingSpinner from "../components/atoms/LoadingSpinner.vue";
import {formatDate} from "../utils/formatDate.ts";
import {useAuthStore} from "../stores/auth.ts";
import router from "../router";
import {useGameStore} from "../stores/gameStore.ts";
import api from "../services/api.ts";

const gameStore = useGameStore();
const showForm = ref(false);
const gameSession = ref<GameSession | null>(null);
const successMessage = ref(false);
const isLoading = ref(true);
const formattedDate = ref('');

const loadFeaturedSession = async () => {
  isLoading.value = true;
  try {
    gameSession.value = await fetchFeaturedGameSession();
    if (gameSession.value) {
      formattedDate.value = formatDate(gameSession.value.date);
    }
  } catch (error) {
    console.error('Error loading upcoming session:', error);
  } finally {
    isLoading.value = false;
    await nextTick()
  }
};

const handleRegisterClick = async() => {
  showForm.value = true;
  await nextTick();
  animate(
      '.registration-form',
      {
        opacity: [0, 1],
        translateY: [20, 0],
        duration: 600,
        easing: 'ease-out-cubic'
      }
  );
};

const handleStartClick = async () => {
  // TODO : Normalize game sessions counters to 0 in gameSessionService
  if (!gameSession.value ||
      (gameSession.value.playlists_count ?? 0) === 0
  ) {
    return;
  }
  try {
    await gameStore.startGame(gameSession.value.id);

    await router.push(`/game`);
  } catch (error) {
    console.error('Failed to start session:', error);
  }
}

const handleEndClick = async () => {
  if (!gameSession.value) return;

  try {
    // Récupérer les playlists et interludes du jeu en cours avant de terminer
    const currentGame = gameStore.currentGame;

    await gameStore.endGame();

    // Marquer les playlists et interludes comme played/done
    if (currentGame) {
      const playlistIds = currentGame.playlists.map(p => p.id);
      const interludeIds = currentGame.interludes.map(i => i.id);

      // Appeler les endpoints pour marquer comme played/done
      await Promise.all([
        ...playlistIds.map(id => api.patch(`/playlists/${id}/mark_played`)),
        ...interludeIds.map(id => api.patch(`/interludes/${id}/mark_done`))
      ]);
    }

    gameSession.value = await fetchFeaturedGameSession();
  } catch (error) {
    console.error('Failed to end session:', error);
  }
}

const teamRegisteredCallback = async () => {
  gameSession.value = await fetchFeaturedGameSession()
  successMessage.value = true;
  await nextTick();
  animate(
      '.registration-form',
      {
        opacity: [1, 0],
        translateY: [-20, 0],
        duration: 600,
        easing: 'ease-out-cubic',
        complete: () => {
          showForm.value = false;
          animate(
              '.success-message',
              {
                opacity: [0, 1],
                translateY: [0, -20],
                duration: 600,
                complete: () => {
                  successMessage.value = false;
                }
              }
          )
        }
      },
  )
};

const teamCancelCallback = async () => {
  showForm.value = false;
}

const isAdmin = (computed(() => useAuthStore().isAuthenticated))

onMounted(() => {
  loadFeaturedSession();
});
</script>

<template>
  <LoadingSpinner v-if="isLoading"/>

  <div v-else-if="gameSession" class="mb-4">
    <div class="p-4 bg-slate-600 rounded-2xl shadow-2xl transform hover:scale-105 transition-transform">
      <div class="flex items-center gap-3 mb-4">
        <CalendarIcon class="h-8 w-8 text-white" />
        <h2 class="text-2xl font-bold text-white">
          {{ gameSession.status === 'upcoming' ? formattedDate :'Ongoing' }}
        </h2>
      </div>

      <div class="mb-4">
        <div class="mb-4 flex justify-between items-center border-b pb-2 border-white/20">
          <div>
            <p class="text-white/90 text-lg flex flex-col gap-1">
              <span class="font-bold">#{{ gameSession.number }}</span>
            </p>
            <div class="flex items-center gap-5">
              <div class="flex items-center gap-1">
                <MusicalNoteIcon class="h-4 w-4" />
                <span>{{ gameSession.playlists_count || 0 }} playlists</span>
              </div>
              <div class="flex items-center gap-1">
                <MicrophoneIcon class="h-4 w-4" />
                <span>{{ gameSession.interludes_count || 0 }} interludes</span>
              </div>
            </div>
          </div>
          <RouterLink
              v-if="isAdmin"
              :to="{ name: 'game-session-detail', params: { id: gameSession.id }}"
          >
            <button class="btn secondary">Edit</button>
          </RouterLink>
        </div>

        <div v-if="gameSession.teams && gameSession.teams.length > 0 && !showForm" class="space-y-2">
          <h3 class="text-white font-semibold flex items-center gap-2">
            <UserGroupIcon class="h-5 w-5" />
            Registered Teams
            <span v-if="gameSession.teams.length > 0">— {{ gameSession.teams.length }}</span>
          </h3>
          <div class="grid gap-2 max-h-60 overflow-y-auto relative">

            <span
                v-if="!successMessage"
                class="success-message bg-green-500 p-2 absolute top-[50%] w-[60%] mx-auto left-0 right-0 top-0 text-white text-center font-semibold rounded-lg z-10 opacity-0 transition scale-0"
            >Team added</span>
            <div
                v-for="team in gameSession.teams"
                :key="team.id"
                class="bg-white/20 rounded-lg p-3 flex justify-between items-center"
            >
              <span class="text-white font-medium">{{ team.name }}</span>
              <span class="text-white/80 text-sm">{{ team.player_count }} players</span>
            </div>
          </div>
        </div>
        <div v-else-if="showForm"
             class="registration-form opacity-0"
        >
          <TeamForm
              mode="register"
              :session="gameSession"
              @done="teamRegisteredCallback"
              @cancel="teamCancelCallback"
          />
        </div>
        <div v-else class="text-white/70 text-center py-2">
          No teams registered yet
        </div>
      </div>

      <div v-if="!showForm" class="text-center flex flex-col gap-2">
        <button
            @click="handleRegisterClick"
            class="btn secondary w-full"
        >
          {{ isAdmin ? 'Register a team' : 'Register your team'}}
        </button>
        <button
            v-if="isAdmin"
            @click="handleStartClick"
            :disabled="gameSession.playlists_count === 0"
            class="btn primary w-full"
        >
          {{ gameSession.status === "ongoing" ? 'Access' : 'Start'}} session
        </button>
        <button
            v-if="isAdmin && gameStore.currentGame"
            @click="handleEndClick"
            class="btn cancel w-full"
        >
          End session
        </button>
      </div>
    </div>
  </div>

  <div v-else class="bg-gray-800 rounded-2xl p-8 text-center mb-8">
    <p class="text-white text-xl mb-2">No ongoing or upcoming game sessions</p>
    <p class="text-gray-400">Check back soon for the next event!</p>
  </div>
</template>
