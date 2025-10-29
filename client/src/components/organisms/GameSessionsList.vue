<script setup lang="ts">
import { computed } from 'vue';
import type { GameSession } from '../../types/gameSession';
import GameSessionCard from '../molecules/GameSessionCard.vue';
import CollapsibleSection from '../molecules/CollapsibleSection.vue';

const props = defineProps<{
  gameSessions: GameSession[];
}>();

const upcomingSessions = computed(() =>
    props.gameSessions.filter(gs => gs.upcoming)
);

const pastSessions = computed(() =>
    props.gameSessions.filter(gs => !gs.upcoming)
);
</script>

<template>
  <div class="space-y-6">
    <CollapsibleSection
        title="Upcoming"
        :count="upcomingSessions.length"
        :defaultOpen="true"
    >
      <GameSessionCard
          v-for="gameSession in upcomingSessions"
          :key="gameSession.id"
          :game-session="gameSession"
      />

      <div v-if="upcomingSessions.length === 0" class="text-center py-8 text-gray-500">
        No upcoming game sessions
      </div>
    </CollapsibleSection>

    <CollapsibleSection
        title="Past"
        :count="pastSessions.length"
        :defaultOpen="false"
    >
      <GameSessionCard
          v-for="gameSession in pastSessions"
          :key="gameSession.id"
          :game-session="gameSession"
      />

      <div v-if="pastSessions.length === 0" class="text-center py-8 text-gray-500">
        No past game sessions yet
      </div>
    </CollapsibleSection>
  </div>
</template>