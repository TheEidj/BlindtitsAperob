
<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { getInterludes } from '../services/interludeService';
import type { Interlude } from '../types/interlude';
import InterludesList from '../components/organisms/InterludesList.vue';
import InterludeForm from '../components/organisms/InterludeForm.vue';
import LoadingSpinner from '../components/atoms/LoadingSpinner.vue';
import BaseModal from '../components/atoms/BaseModal.vue';
import { PlusIcon } from '@heroicons/vue/24/solid';
import { animate } from 'animejs';

const interludes = ref<Interlude[]>([]);
const loading = ref(true);
const showCreateModal = ref(false);

const loadInterludes = async () => {
  loading.value = true;
  try {
    interludes.value = await getInterludes();
  } catch (error) {
    console.error('Failed to load interludes:', error);
  } finally {
    loading.value = false;
  }
};

onMounted(() => {
  loadInterludes();

  animate('.add-button', {
    scale: [0, 1],
    rotate: ['180deg', '0deg'],
    duration: 800,
    delay: 500,
    easing: 'ease-out-elastic',
  });
});
</script>

<template>
  <h1 class="text-3xl font-bold text-white mb-8">Interludes</h1>

  <!-- Floating Add Button -->
  <button
      @click="showCreateModal = true"
      class="add-button fixed bottom-24 right-6 bg-gradient-to-r from-indigo-600 to-purple-600 text-white p-4 rounded-full shadow-2xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-300 z-40"
  >
    <PlusIcon class="h-8 w-8" />
  </button>

  <!-- Create Modal -->
  <BaseModal
      title="Create New Interlude"
      :show="showCreateModal"
      @close="showCreateModal = false"
  >
    <template #content>
      <InterludeForm
          mode="create"
          @done="
            () => {
              showCreateModal = false;
              loadInterludes();
            }
          "
      />
    </template>
  </BaseModal>

  <LoadingSpinner v-if="loading" />

  <InterludesList v-else :interludes="interludes" />
</template>