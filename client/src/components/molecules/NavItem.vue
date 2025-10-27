<script setup lang="ts">
import { computed, type Component } from 'vue';
import { useRoute, useRouter } from 'vue-router';

const props = defineProps<{
  to: string;
  label: string;
  icon: Component;
}>();

const route = useRoute();
const router = useRouter();

const isActive = computed(() => route.path === props.to);

const navigate = () => {
  router.push(props.to);
};
</script>

<template>
  <button
      @click="navigate"
      class="flex flex-col items-center gap-1 flex-1 py-2 transition-colors"
      :class="isActive ? 'text-indigo-400' : 'text-gray-400 hover:text-gray-300'"
  >
    <component :is="icon" class="h-6 w-6" />
    <span class="text-xs font-medium">{{ label }}</span>
  </button>
</template>