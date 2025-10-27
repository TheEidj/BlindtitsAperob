<script setup lang="ts">
import { CheckCircleIcon } from '@heroicons/vue/24/solid';
import { CheckCircleIcon as CheckCircleOutlineIcon } from '@heroicons/vue/24/outline';

defineProps<{
  played: boolean;
  disabled?: boolean;
}>();

const emit = defineEmits<{
  toggle: [];
}>();
</script>


<template>
  <button
      @click="emit('toggle')"
      :disabled="disabled"
      class="flex items-center gap-2 transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
      :class="played ? 'text-green-500 hover:text-green-400' : 'text-gray-500 hover:text-gray-400'"
  >
    <CheckCircleIcon v-if="played" class="h-6 w-6" />
    <CheckCircleOutlineIcon v-else class="h-6 w-6" />
    <span class="text-sm font-medium">{{ played ? 'Played' : 'Not played' }}</span>
  </button>
</template>

<style scoped>

</style>