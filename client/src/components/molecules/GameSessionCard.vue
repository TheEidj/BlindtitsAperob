<script setup lang="ts">
import { computed } from 'vue';
import type { GameSession } from '../../types/gameSession';
import { CalendarIcon, MusicalNoteIcon, UserGroupIcon } from '@heroicons/vue/24/outline';

const props = defineProps<{
  gameSession: GameSession;
}>();

const emit = defineEmits<{
  click: [];
}>();

const formatDate = (dateString: string) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('fr-FR', {
    weekday: 'short',
    month: 'short',
    year: 'numeric',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

const statusColor = computed(() =>
    props.gameSession.upcoming ? 'bg-green-500' : 'bg-gray-500'
);

const statusText = computed(() =>
    props.gameSession.upcoming ? 'Upcoming' : 'Past'
);
</script>

<template>
  <div
      @click="emit('click')"
      class="bg-gray-800 rounded-xl p-4 hover:bg-gray-750 transition-all duration-300 cursor-pointer border border-gray-700 hover:border-indigo-500 group"
  >
    <div class="flex items-center justify-between mb-3">
      <div class="flex items-center gap-2">
        <CalendarIcon class="h-5 w-5 text-indigo-400" />
        <span class="text-white font-medium">{{ formatDate(gameSession.date) }}</span>
      </div>
      <span
          :class="statusColor"
          class="px-3 py-1 rounded-full text-xs font-bold text-white"
      >
        {{ statusText }}
      </span>
    </div>

    <div class="flex gap-4 text-sm text-gray-400">
      <div class="flex items-center gap-1">
        <UserGroupIcon class="h-4 w-4" />
        <span>{{ gameSession.teams_count || 0 }} teams</span>
      </div>
      <div class="flex items-center gap-1">
        <MusicalNoteIcon class="h-4 w-4" />
        <span>{{ gameSession.playlists_count || 0 }} playlists</span>
      </div>
    </div>
  </div>
</template>