<script setup lang="ts">
import { ref } from 'vue';
import { ChevronDownIcon, ChevronUpIcon } from '@heroicons/vue/24/outline';

defineProps<{
  title: string;
  count: number;
  defaultOpen?: boolean;
}>();

const isOpen = ref(true);

const toggle = () => {
  isOpen.value = !isOpen.value;
};
</script>

<template>
  <div class="border border-gray-700 rounded-lg overflow-hidden">
    <button
        @click="toggle"
        class="w-full px-4 py-3 bg-gray-800 hover:bg-gray-750 flex items-center justify-between transition-colors"
    >
      <div class="flex items-center gap-3">
        <h2 class="text-lg font-semibold">{{ title }}</h2>
        <span class="px-2 py-1 bg-gray-700 rounded text-sm">{{ count }}</span>
      </div>
      
      <ChevronUpIcon v-if="isOpen" class="h-5 w-5 text-gray-400" />
      <ChevronDownIcon v-else class="h-5 w-5 text-gray-400" />
    </button>
    
    <div v-show="isOpen" class="p-4 space-y-3 bg-gray-900">
      <slot />
    </div>
  </div>
</template>

<style scoped>

</style>