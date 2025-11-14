<script setup lang="ts">
import { computed } from 'vue'
import { useGameStore } from '../../stores/gameStore'

const gameStore = useGameStore()

const activeTab = computed(() => gameStore.currentGameTab)

function goTo(tab: 'teams' | 'playlists' | 'interludes') {
  gameStore.setGameTab(tab)
}
</script>

<template>
  <nav class="fixed bottom-0 left-0 right-0 pb-4">
    <div class="max-w-5xl mx-auto px-4">
      <div class="flex bg-black/60 backdrop-blur-xl rounded-2xl border border-white/10 shadow-2xl">
        <button
            class="flex-1 py-3 text-xs font-medium uppercase tracking-[0.2em] transition-all"
            :class="activeTab === 'teams'
            ? 'text-white bg-white/10'
            : 'text-white/50 hover:text-white'"
            @click="goTo('teams')"
        >
          Teams
        </button>
        <button
            class="flex-1 py-3 text-xs font-medium uppercase tracking-[0.2em] transition-all"
            :class="activeTab === 'playlists'
            ? 'text-white bg-white/10'
            : 'text-white/50 hover:text-white'"
            @click="goTo('playlists')"
        >
          Playlists
        </button>
        <button
            class="flex-1 py-3 text-xs font-medium uppercase tracking-[0.2em] transition-all"
            :class="activeTab === 'interludes'
            ? 'text-white bg-white/10'
            : 'text-white/50 hover:text-white'"
            @click="goTo('interludes')"
        >
          Interludes
        </button>
      </div>
    </div>
  </nav>
</template>