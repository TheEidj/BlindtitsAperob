<script setup lang="ts">
import { UserGroupIcon } from '@heroicons/vue/24/outline';
import {computed} from "vue";

const props = defineProps<{
  isMine: boolean;
  isFollowed: boolean;
  nbTrack: number;
  isCollaborative: boolean;
}>();

const trackText = computed(() => {
  const count = props.nbTrack;
  return `${count} track${count !== 1 ? 's' : ''}`;
});
</script>

<template>
  <div class="flex items-center gap-2 mt-2">
    <span
        v-if="isMine"
        class="px-2 py-1 text-xs rounded bg-indigo-600"
    >
    OWNED
    </span>
    <span
        v-else-if="isFollowed"
        class="px-2 py-1 text-xs rounded bg-green-600"
    >
    FOLLOWED
    </span>
    <span
        v-else
        class="px-2 py-1 text-xs rounded bg-red-600"
    >
    NOT FOLLOWED
  </span>
    <span
        v-if="isCollaborative"
        class="px-2 py-1 text-xs rounded bg-gray-600"
    >
    <UserGroupIcon class="h-4 w-4 inline-block" />
    </span>
    <span class="px-2 py-1 text-xs rounded bg-gray-600">
    {{ trackText }}
    </span>
  </div>
</template>
