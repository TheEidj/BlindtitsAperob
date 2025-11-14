<script setup lang="ts">
import { ref, watch } from 'vue';
import type { Interlude } from '../../types/interlude';
import { saveInterlude } from '../../services/interludeService';

const props = defineProps<{
  mode: 'create' | 'edit';
  interlude?: Interlude;
  submitLabel?: string;
}>();

const emit = defineEmits<{
  (e: 'done'): void;
}>();

const form = ref({
  title: '',
  lyrics: '',
  done: false,
});

watch(
    () => props.interlude,
    (i) => {
      if (!i) return;
      form.value = {
        title: i.title,
        lyrics: i.lyrics,
        done: i.done,
      };
    },
    { immediate: true }
);

const handleSubmit = async () => {
  await saveInterlude({
    id: props.interlude?.id ?? undefined,
    title: form.value.title,
    lyrics: form.value.lyrics,
    done: form.value.done,
  });
  emit('done');
};
</script>

<template>
  <div class="space-y-4">
    <div>
      <label class="block text-gray-700 font-medium mb-2">Title</label>
      <input
          v-model="form.title"
          type="text"
          class="w-full px-4 py-2 rounded-lg bg-white border border-gray-300 text-gray-900 focus:outline-none focus:ring-2 focus:ring-indigo-500"
          placeholder="Enter interlude title"
      />
    </div>

    <div>
      <label class="block text-gray-700 font-medium mb-2">Lyrics</label>
      <textarea
          v-model="form.lyrics"
          rows="8"
          class="w-full px-4 py-2 rounded-lg bg-white border border-gray-300 text-gray-900 focus:outline-none focus:ring-2 focus:ring-indigo-500"
          placeholder="Enter lyrics (rich text)"
      />
    </div>

    <div class="flex items-center">
      <input
          v-model="form.done"
          type="checkbox"
          id="done-checkbox"
          class="w-4 h-4 text-indigo-600 rounded focus:ring-indigo-500"
      />
      <label for="done-checkbox" class="ml-2 text-gray-700 font-medium">
        Mark as done
      </label>
    </div>

    <button
        @click="handleSubmit"
        :disabled="!form.title"
        class="w-full bg-indigo-600 text-white px-6 py-3 rounded-lg font-bold hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-300"
    >
      {{ submitLabel ?? (mode === 'create' ? 'Create' : 'Save') }}
    </button>
  </div>
</template>