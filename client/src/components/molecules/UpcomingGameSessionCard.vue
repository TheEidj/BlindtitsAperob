<script setup lang="ts">
import {nextTick, ref} from 'vue';
import type { GameSession } from '../../types/gameSession';
import { CalendarIcon, UserGroupIcon } from '@heroicons/vue/24/outline';
import { animate } from 'animejs';

defineProps<{
  gameSession: GameSession;
}>();

const emit = defineEmits<{
  register: [teamName: string, playerCount: number];
}>();

const showForm = ref(false);
const teamName = ref('');
const playerCount = ref(2);
const isSubmitting = ref(false);
const successMessage = ref('');

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

const handleRegisterClick = () => {
  showForm.value = true;
  nextTick();
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

const handleSubmit = async () => {
  if (!teamName.value.trim()) return;
  
  isSubmitting.value = true;
  
  try {
    emit('register', teamName.value, playerCount.value);
    
    successMessage.value = '🎉 Team registered successfully!';
    await nextTick();
    animate(
        '.success-message',
        {
          scale: [0.8, 1],
          opacity: [0, 1],
          duration: 800,
          easing: 'ease-out-elastic'
        }
    );
    
    setTimeout(() => {
      showForm.value = false;
      teamName.value = '';
      playerCount.value = 2;
      successMessage.value = '';
    }, 2000);
  } finally {
    isSubmitting.value = false;
  }
};
</script>

<template>
  <div class="bg-gradient-to-br from-indigo-600 to-purple-700 rounded-2xl p-6 shadow-2xl transform hover:scale-105 transition-transform duration-300">
    <div class="flex items-center gap-3 mb-4">
      <CalendarIcon class="h-8 w-8 text-white" />
      <h2 class="text-2xl font-bold text-white">Next Game Session</h2>
    </div>
    
    <div class="bg-white/10 backdrop-blur-sm rounded-xl p-4 mb-4">
      <p class="text-white/90 text-lg mb-3">
        {{ formatDate(gameSession.date) }}
      </p>
      
      <div v-if="gameSession.teams && gameSession.teams.length > 0" class="space-y-2">
        <h3 class="text-white font-semibold flex items-center gap-2">
          <UserGroupIcon class="h-5 w-5" />
          Registered Teams
        </h3>
        <div class="grid gap-2">
          <div
            v-for="team in gameSession.teams"
            :key="team.id"
            class="bg-white/20 rounded-lg p-3 flex justify-between items-center"
            :style="{ borderLeft: `4px solid ${team.color}` }"
          >
            <span class="text-white font-medium">{{ team.name }}</span>
            <span class="text-white/80 text-sm">{{ team.player_count }} players</span>
          </div>
        </div>
      </div>
      
      <div v-else class="text-white/70 text-center py-2">
        No teams registered yet. Be the first!
      </div>
    </div>
    
    <div v-if="!showForm && !successMessage" class="text-center">
      <button
        @click="handleRegisterClick"
        class="bg-white text-indigo-600 px-8 py-3 rounded-full font-bold text-lg hover:bg-indigo-50 transition-all duration-300 shadow-lg hover:shadow-xl"
      >
        Register Your Team
      </button>
    </div>
    
    <div v-if="showForm" class="registration-form space-y-4 bg-white/20 rounded-xl p-4">
      <div>
        <label class="block text-white font-medium mb-2">Team Name</label>
        <input
          v-model="teamName"
          type="text"
          class="w-full px-4 py-2 rounded-lg bg-white/90 text-gray-900 focus:outline-none focus:ring-2 focus:ring-white"
          placeholder="Enter your team name"
        />
      </div>
      
      <div>
        <label class="block text-white font-medium mb-2">Number of Players</label>
        <input
          v-model.number="playerCount"
          type="number"
          min="1"
          max="10"
          class="w-full px-4 py-2 rounded-lg bg-white/90 text-gray-900 focus:outline-none focus:ring-2 focus:ring-white"
        />
      </div>
      
      <button
        @click="handleSubmit"
        :disabled="isSubmitting || !teamName.trim()"
        class="w-full bg-white text-indigo-600 px-6 py-3 rounded-lg font-bold hover:bg-indigo-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-300"
      >
        {{ isSubmitting ? 'Registering...' : 'Submit' }}
      </button>
    </div>
    
    <div v-if="successMessage" class="success-message text-center text-white text-xl font-bold py-4">
      {{ successMessage }}
    </div>
  </div>
</template>
