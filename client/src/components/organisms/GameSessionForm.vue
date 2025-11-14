<script setup lang="ts">
import { ref, watch } from 'vue'
import { saveGameSession } from '../../services/gameSessionService' // ↓ tu vas créer ça
import type { GameSession } from '../../types/gameSession'

const props = defineProps<{
  mode: 'create' | 'edit'
  session?: GameSession
  submitLabel?: string
}>()

const options = ref([
  { text: 'Upcoming', value: 'upcoming' },
  { text: 'Ongoing', value: 'ongoing' },
  { text: 'Archived', value: 'archived' }
])

const emit = defineEmits<{
  (e:'done'): void
}>()

// TODO: Retrieve higher number of sessions and set it as default+1
const form = ref({
  date: '',
  status: 'archived',
  playerCount: '',
})

watch(() => props.session, (s) => {
  if (!s) return
  form.value = {
    date: new Date(s.date).toISOString().slice(0,16),
    status: s.status,
    playerCount: String(s.number)
  }
}, { immediate: true })

const handleSubmit = async () => {
  await saveGameSession({
    id: props.session?.id,
    date: form.value.date,
    status: form.value.status,
    playerCount: parseInt(form.value.playerCount)
  })
  emit('done')
}
</script>

<template>
  <div class="space-y-4">
    <div>
      <label class="block text-white font-medium mb-2">Scheduled Date & Time</label>
      <input v-model="form.date" type="datetime-local"
             class="w-full px-4 py-3 rounded-lg bg-gray-700 text-white"/>
    </div>

    <div class="grid grid-cols-2 gap-3">
      <div>
        <label class="block text-white font-medium mb-2">N°</label>
        <input v-model="form.playerCount" type="number"
               class="w-full px-4 py-3 rounded-lg bg-gray-700 text-white"/>
      </div>

      <div>
        <div class="block text-white font-medium mb-2">Status</div>
        <select v-model="form.status"
                class="w-full h-[48px] px-4 py-3 rounded-lg bg-gray-700 text-white">
          <option v-for="option in options" :value="option.value"> {{ option.text }} </option>
        </select>
      </div>
    </div>

    <button
        @click="handleSubmit"
        :disabled="!form.date || !form.playerCount"
        class="w-full px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
    >
      {{ submitLabel ?? (mode === 'create' ? 'Create' : 'Save') }}
    </button>
  </div>
</template>
