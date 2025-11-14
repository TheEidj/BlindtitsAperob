<script setup lang="ts">
import { PlusIcon } from '@heroicons/vue/24/outline';

defineProps<{
  title: string;
  icon: any;
}>();

const emit = defineEmits<{
  (e: 'add'): void;
}>();
</script>

<template>
  <div class="flex items-center justify-between mb-4">
    <div class="flex items-center gap-3">
      <component :is="icon" class="h-6 w-6 text-indigo-400" />
      <h2 class="text-xl font-bold text-white">{{ title }}</h2>
    </div>
    <button
        @click="emit('add')"
        class="p-2 rounded-lg bg-indigo-600 hover:bg-indigo-700 transition-colors"
    >
      <PlusIcon class="h-5 w-5 text-white" />
    </button>
  </div>
</template>