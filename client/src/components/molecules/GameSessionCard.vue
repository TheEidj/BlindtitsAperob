<script setup lang="ts">
import { computed } from "vue";
import type { GameSession } from "../../types/gameSession";
import { CalendarIcon, MusicalNoteIcon, UserGroupIcon, MicrophoneIcon } from '@heroicons/vue/24/outline';
import {useSwipeNavigate} from "../../composables/useSwipeNavigate";
import {formatDate} from "../../utils/formatDate";

const props = defineProps<{
  gameSession: GameSession;
}>();

const { cardRef, onClick } = useSwipeNavigate(`/game-sessions/${props.gameSession.id}`);

const formattedDate = formatDate(props.gameSession.date)

const statusColor = computed(() =>
    props.gameSession.status === 'ongoing' ? 'bg-green-500' : 'bg-gray-500'
);

const statusText = computed(() =>
    props.gameSession.status
);
</script>

<template>
  <div
      ref="cardRef"
      @click="onClick"
      class="card bg-gray-800 border border-gray-700 rounded-xl p-4 hover:border-indigo-500 transition-colors cursor-pointer select-none touch-none"
  >
    <div class="flex gap-2 flex-col mb-3">
        <div v-if="gameSession.number" class="flex items-center justify-between pointer-events-none">
          <span class="text-white font-medium">#{{ gameSession.number }}</span>

          <span
              :class="statusColor"
              class="px-3 py-1 rounded-full text-xs font-bold text-white pointer-events-none"
          >
        {{ statusText }}
      </span>
        </div>
        <div v-if="gameSession.date" class="flex items-center gap-2 pointer-events-none">
          <CalendarIcon class="h-5 w-5 text-indigo-400" />
          <span class="text-white font-medium">{{ formattedDate }}</span>
        </div>
      </div>

    <div class="flex justify-between text-sm text-gray-400 mb-2 pointer-events-none">
      <div class="flex items-center gap-5">
        <div class="flex items-center gap-1">
          <UserGroupIcon class="h-4 w-4" />
          <span>{{ gameSession.teams_count || 0 }}</span>
        </div>
        <div class="flex items-center gap-1">
          <MusicalNoteIcon class="h-4 w-4" />
          <span>{{ gameSession.playlists_count || 0 }}</span>
        </div>
        <div class="flex items-center gap-1">
          <MicrophoneIcon class="h-4 w-4" />
          <span>{{ gameSession.interludes_count || 0 }}</span>
        </div>
      </div>
      <div class="text-indigo-400 text-2xl opacity-60 text-right pointer-events-none">
        →
      </div>
    </div>
  </div>
</template>