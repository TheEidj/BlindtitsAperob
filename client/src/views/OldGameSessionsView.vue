<script setup lang="ts">
import {ref, onMounted, nextTick} from 'vue';
import { useRouter } from 'vue-router';
import type { GameSession } from '../types/gameSession';
import { fetchPastGameSessions } from '../services/gameSessionService';
import { ArrowLeftIcon } from '@heroicons/vue/24/outline';
import { animate } from 'animejs';

const router = useRouter();
const pastSessions = ref<GameSession[]>([]);
const isLoading = ref(true);
const selectedSessionId = ref<number | null>(null);
const containerRef = ref<HTMLElement | null>(null);
const startX = ref(0);
const currentX = ref(0);
const isDragging = ref(false);

const loadPastSessions = async () => {
  isLoading.value = true;
  try {
    pastSessions.value = await fetchPastGameSessions();

    await nextTick();
    animate(
        '.session-card',
        {
          opacity: [0, 1],
          translateY: [30, 0]
        },
        {
          delay: stagger(100),
          duration: 600,
          easing: 'ease-out-cubic'
        }
    );
  } catch (error) {
    console.error('Error loading past sessions:', error);
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

const handleTouchStart = (e: TouchEvent, sessionId: number) => {
  startX.value = e.touches[0].clientX;
  isDragging.value = true;
  selectedSessionId.value = sessionId;
};

const handleTouchMove = (e: TouchEvent) => {
  if (!isDragging.value) return;
  currentX.value = e.touches[0].clientX - startX.value;
};

const handleTouchEnd = () => {
  if (Math.abs(currentX.value) > 100 && selectedSessionId.value) {
    router.push(`/game-sessions/${selectedSessionId.value}`);
  }

  isDragging.value = false;
  currentX.value = 0;
  selectedSessionId.value = null;
};

const goBack = () => {
  animate(
      '.old-sessions-container',
      {
        opacity: [1, 0],
        translateX: [0, 100]
      },
      {
        duration: 400,
        easing: 'ease-in-cubic',
        complete: () => {
          router.push('/');
        }
      }
  );
};

onMounted(() => {
  loadPastSessions();

  animate(
      '.page-title',
      {
        opacity: [0, 1],
        translateY: [-20, 0]
      },
      {
        duration: 600,
        easing: 'ease-out-cubic'
      }
  );
});
</script>

<template>
  <div class="old-sessions-container min-h-screen bg-gradient-to-br from-gray-900 via-gray-800 to-purple-900 p-6">
    <div class="max-w-4xl mx-auto">
      <div class="flex items-center gap-4 mb-8">
        <button
            @click="goBack"
            class="p-2 rounded-full bg-gray-800 hover:bg-gray-700 transition-colors"
        >
          <ArrowLeftIcon class="h-6 w-6 text-white" />
        </button>
        <h1 class="page-title text-3xl font-bold text-white opacity-0">
          Past Game Sessions
        </h1>
      </div>

      <div v-if="isLoading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-purple-500 border-t-transparent"></div>
        <p class="text-white mt-4">Loading sessions...</p>
      </div>

      <div v-else-if="pastSessions.length === 0" class="text-center py-12">
        <p class="text-white text-xl">No past game sessions yet</p>
      </div>

      <div v-else class="space-y-4" ref="containerRef">
        <div
            v-for="session in pastSessions"
            :key="session.id"
            class="session-card bg-gray-800 rounded-xl p-6 opacity-0 cursor-pointer hover:bg-gray-750 transition-all border border-gray-700"
            @touchstart="handleTouchStart($event, session.id)"
            @touchmove="handleTouchMove"
            @touchend="handleTouchEnd"
            :style="{
            transform: selectedSessionId === session.id ? `translateX(${currentX}px)` : 'translateX(0)',
            transition: isDragging ? 'none' : 'transform 0.3s ease'
          }"
        >
          <div class="flex items-center justify-between mb-4">
            <h3 class="text-white font-bold text-lg">
              {{ formatDate(session.date) }}
            </h3>
            <span class="text-gray-400 text-sm">Swipe to view details →</span>
          </div>

          <div class="flex gap-6 text-gray-400">
            <div>
              <span class="font-semibold">Teams:</span> {{ session.teams?.length || 0 }}
            </div>
            <div>
              <span class="font-semibold">Playlists:</span> {{ session.playlists?.length || 0 }}
            </div>
          </div>

          <div v-if="session.teams && session.teams.length > 0" class="mt-4 flex flex-wrap gap-2">
            <div
                v-for="team in session.teams"
                :key="team.id"
                class="px-3 py-1 rounded-full text-sm text-white"
                :style="{ backgroundColor: team.color }"
            >
              {{ team.name }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>