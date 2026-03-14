<script setup lang="ts">
import { UserGroupIcon } from '@heroicons/vue/24/outline';
import {computed} from "vue";

const props = defineProps<{
  isMine: boolean;
  isFollowed: boolean;
  nbTrack: number;
  isCollaborative: boolean;
  creatorName?: string;
}>();

const trackText = computed(() => {
  const count = props.nbTrack;
  return `${count} track${count !== 1 ? 's' : ''}`;
});

const trackColorClass = computed(() => {
  if (props.nbTrack < 5) return 'bg-red-600';
  if (props.nbTrack < 10) return 'bg-yellow-600';
  return 'bg-green-600';
});
</script>

<template>
  <div class="flex items-center gap-2 mt-2">
    <span
        v-if="creatorName"
        class="px-2 py-1 text-xs rounded bg-blue-600"
    >
      {{ creatorName }}
    </span>
    <span
        v-if="isCollaborative"
        class="px-2 py-1 text-xs rounded bg-gray-600"
    >
      <UserGroupIcon class="h-4 w-4 inline-block" />
    </span>
    <span :class="['px-2 py-1 text-xs rounded', trackColorClass]">
      {{ trackText }}
    </span>
  </div>
</template>
