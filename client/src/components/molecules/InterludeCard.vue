<script setup lang="ts">
import { ref } from 'vue';
import type { Interlude } from '../../types/interlude';
import { CheckCircleIcon } from '@heroicons/vue/24/solid';
import InterludeForm from "../organisms/InterludeForm.vue";

defineProps<{
  interlude: Interlude;
}>();

const emit = defineEmits<{
  (e: 'updated'): void
}>()

const isEditing = ref(false)

const startEdit = () => {
  isEditing.value = true
}

const handleDone = () => {
  isEditing.value = false
  emit('updated')
}
</script>

<template>
  <div class="bg-white rounded-lg shadow-md p-4 hover:shadow-lg transition-shadow">
    <!-- Mode édition -->
    <div v-if="isEditing" class="space-y-4">
      <InterludeForm
          mode="edit"
          :interlude="interlude"
          submitLabel="Save"
          @done="handleDone"
      />
    </div>

    <!-- Mode affichage -->
    <button
        v-else
        type="button"
        class="w-full text-left"
        @click="startEdit"
    >
      <div class="flex items-start justify-between">
        <div class="flex-1">
          <h3 class="font-bold text-lg text-gray-900">{{ interlude.title }}</h3>
          <p class="text-gray-600 text-sm mt-2 whitespace-pre-wrap line-clamp-3">
            {{ interlude.lyrics }}
          </p>
        </div>

        <CheckCircleIcon
            v-if="interlude.done"
            class="w-6 h-6 text-green-500 ml-2 flex-shrink-0"
        />
      </div>
    </button>
  </div>
</template>