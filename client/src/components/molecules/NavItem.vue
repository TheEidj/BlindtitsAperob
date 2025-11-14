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
      :class="isActive ? 'text-purple-800' : 'text-gray-600 hover:text-gray-700'"
  >
    <component :is="icon" class="h-8 w-8" />
    <span class="text-2xs font-medium">{{ label }}</span>
  </button>
</template>