<script setup lang="ts">
import {ref, watch} from "vue";
import type {GameSession} from "../../types/gameSession.ts";
import type { Team } from "../../types/team.ts";
import { saveTeam } from "../../services/teamService";

const props = defineProps<{
  mode: 'register' | 'edit'
  session: GameSession
  team?: Team
  submitLabel?: string
}>()

const emit = defineEmits<{
  (e:'done'): void
  (e:'cancel'): void
}>()

const form = ref({
  teamName: '',
  playerCount: '',
})

watch(() => props.team, (t) => {
  if (!t) return
  form.value = {
    teamName: String(t.name),
    playerCount: String(t.player_count),
  }
}, { immediate: true })

const handleSubmit = async () => {
  await saveTeam({
    id: props.team?.id,
    gameSessionId: props.session.id,
    teamName: form.value.teamName,
    playerCount: parseInt(form.value.playerCount),
  })
  emit('done')
}

</script>

<template>
  <div class="flex flex-col gap-4">
    <div>
      <label class="block text-white font-medium mb-2">Team Name</label>
      <input
          v-model="form.teamName"
          type="text"
          class="w-full px-4 py-2 rounded-lg bg-white/90 text-gray-900 focus:outline-none focus:ring-2 focus:ring-white"
          placeholder="Enter your team name"
      />
    </div>
    <div>
      <label class="block text-white font-medium mb-2">Number of Players</label>
      <input
          v-model="form.playerCount"
          type="number"
          min="1"
          max="10"
          class="w-full px-4 py-2 rounded-lg bg-white/90 text-gray-900 focus:outline-none focus:ring-2 focus:ring-white"
      />
    </div>
    <div class="flex flex-col gap-2">
      <button
          @click="handleSubmit"
          :disabled="!form.teamName || !form.playerCount"
          class="btn secondary"
      >
        {{ submitLabel ?? (mode === 'register' ? 'Register' : 'Save') }}
      </button>
      <button
          @click="emit('cancel')"
          class="btn btn-cancel"
      >
        Cancel
      </button>
    </div>
  </div>
</template>