<script setup lang="ts">
import { computed } from 'vue';
import type { GameSession } from '../../types/gameSession';
import GameSessionCard from '../molecules/GameSessionCard.vue';
import CollapsibleSection from '../molecules/CollapsibleSection.vue';

const props = defineProps<{
  gameSessions: GameSession[];
}>();

const ongoingSession = computed(() =>
    props.gameSessions.filter(gs => gs.status === 'ongoing')
);

const upcomingSessions = computed(() =>
    props.gameSessions.filter(gs => gs.status === 'upcoming')
);

const archivedSessions = computed(() =>
    props.gameSessions.filter(gs => gs.status === 'archived')
);
</script>

<template>
  <div class="space-y-6">
    <CollapsibleSection
        title="Ongoing"
        :count="ongoingSession.length"
        :defaultOpen="true"
    >
      <GameSessionCard
          v-for="gameSession in ongoingSession"
          :key="gameSession.id"
          :game-session="gameSession"
      />

      <div v-if="ongoingSession.length === 0" class="text-center py-8 text-gray-500">
        No ongoing game session
      </div>
    </CollapsibleSection>

    <CollapsibleSection
        title="Upcoming"
        :count="upcomingSessions.length"
        :defaultOpen="false"
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
        title="Archived"
        :count="archivedSessions.length"
        :defaultOpen="false"
    >
      <GameSessionCard
          v-for="gameSession in archivedSessions"
          :key="gameSession.id"
          :game-session="gameSession"
      />

      <div v-if="archivedSessions.length === 0" class="text-center py-8 text-gray-500">
        No archived game sessions yet
      </div>
    </CollapsibleSection>
  </div>
</template>