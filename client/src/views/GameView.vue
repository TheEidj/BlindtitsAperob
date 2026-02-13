<script setup lang="ts">
import { computed, onMounted, ref, nextTick, watch } from 'vue'
import { useRouter } from 'vue-router'
import { animate, stagger } from 'animejs'
import { useGameStore } from '../stores/gameStore'

const router = useRouter()
const gameStore = useGameStore()

const game = computed(() => gameStore.currentGame)
const teams = computed(() => game.value?.teams || [])
const playlists = computed(() => game.value?.playlists || [])
const interludes = computed(() => game.value?.interludes || [])

const activeTab = computed({
  get: () => gameStore.currentGameTab,
  set: (tab) => gameStore.setGameTab(tab),
})

// Pour le swipe
const swipeAreaRef = ref<HTMLElement | null>(null)
const touchStartX = ref<number | null>(null)
const swipeThreshold = 40 // px

const tabs = ['teams', 'playlists', 'interludes'] as const

onMounted(() => {
  // Si aucune game en cours dans le store, on repart à l'accueil
  if (!gameStore.currentGame) {
    router.push('/')
    return
  }

  // Animation d’entrée des teams
  nextTick(() => {
    animateTeamCards()
  })
})

watch(teams, () => {
  // Ré-animer quand la liste des teams change (score mis à jour serveur)
  nextTick(() => {
    animateTeamCards()
  })
})

// Animation des cartes équipes
function animateTeamCards() {
  if (!teams.value.length) return

  animate('.team-card', {
    opacity: [0, 1],
    translateY: [20, 0],
    scale: [0.95, 1],
    delay: stagger(80),
    duration: 500,
    easing: 'easeOutQuad',
  })
}

// Animation d’un score individuel
function animateScore(teamId: number) {
  const selector = `.score-${teamId}`
  animate(selector, {
    scale: [1, 1.15, 1],
    duration: 100,
    easing: 'easeOutBack',
  })
}

async function updateScore(teamId: number, delta: number) {
  try {
    await gameStore.updateTeamScore(teamId, delta)
    animateScore(teamId)
  } catch (error) {
    console.error('Failed to update score:', error)
  }
}

function handleClose() {
  router.push('/')
}

// Gestion des onglets
function setTab(tab: (typeof tabs)[number]) {
  activeTab.value = tab
  // petite anim sur le changement de panel
  nextTick(() => {
    if (!swipeAreaRef.value) return
    animate(swipeAreaRef.value, {
      opacity: [0, 1],
      translateX: [20, 0],
      duration: 250,
      easing: 'easeOutQuad',
    })
  })
}

// Swipe gauche/droite pour changer d’onglet
function onTouchStart(event: TouchEvent) {
  const touch = event.touches[0]
  if(!touch) return
  touchStartX.value = touch.clientX
}

function onTouchEnd(event: TouchEvent) {
  if (touchStartX.value === null) return
  const touch = event.changedTouches[0]
  if (!touch) return
  const deltaX = touch?.clientX - touchStartX.value

  if (Math.abs(deltaX) < swipeThreshold) {
    touchStartX.value = null
    return
  }

  const currentIndex = tabs.indexOf(activeTab.value)

  if (deltaX < 0 && currentIndex < tabs.length - 1) {
    // swipe gauche -> onglet suivant
    const nextTab = tabs[currentIndex + 1] as (typeof tabs)[number] | undefined
    if (nextTab) setTab(nextTab)
  } else if (deltaX > 0 && currentIndex > 0) {
    // swipe droite -> onglet précédent
    const prevTab = tabs[currentIndex - 1] as (typeof tabs)[number] | undefined
    if(prevTab) setTab(prevTab)
  }

  touchStartX.value = null
}
</script>

<template>
  <div class="min-h-screen">
    <!-- Header with close button -->
    <div class="max-w-5xl mx-auto mb-4">
      <div class="flex items-center justify-between">
        <button
            @click="handleClose"
            class="w-10 h-10 flex items-center justify-center bg-red-500/20 hover:bg-red-500/40 rounded-full transition-colors"
        >
          <svg class="w-6 h-6 text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
        <div class="text-center flex-1">
          <p class="text-sm text-white/60 uppercase tracking-[0.2em]">
            Live Game
          </p>
          <h1 class="text-2xl font-bold text-white">
            Session #{{ game?.number }}
          </h1>
        </div>
        <div class="w-10"></div>
      </div>
    </div>

    <!-- Swipeable content area -->
    <div
        ref="swipeAreaRef"
        class="min-h-screen"
        @touchstart.passive="onTouchStart"
        @touchend.passive="onTouchEnd"
    >
      <!-- TEAMS TAB -->
      <transition name="fade" mode="out-in">
        <div v-if="activeTab === 'teams'" key="teams">
          <div class="space-y-4">
            <div
                v-for="gameTeam in teams"
                :key="gameTeam.team.id"
                class="team-card relative overflow-hidden bg-white/5 backdrop-blur-xl rounded-2xl p-5 border border-white/10 shadow-lg hover:border-white/40 transition-all"
            >
              <!-- glow -->
              <div
                  class="pointer-events-none absolute inset-0 opacity-30"
                  :style="{
                  background: `radial-gradient(circle at top left, ${gameTeam.color}, transparent 60%)`
                }"
              ></div>

              <div class="relative flex items-center gap-4">
                <!-- Team avatar / color -->
                <div
                    class="w-14 h-14 rounded-2xl border-2 border-white/40 flex items-center justify-center text-xl font-bold text-white shadow-lg"
                    :style="{ backgroundColor: gameTeam.color || '#555666' }"
                >
                  {{ gameTeam.team.name.charAt(0).toUpperCase() }}
                </div>

                <!-- Team info & score -->
                <div class="flex-1 flex items-center justify-between gap-4">
                  <div>
                    <h3 class="text-lg font-semibold text-white">
                      {{ gameTeam.team.name }}
                    </h3>
                    <p class="text-xs text-white/60">
                      {{ gameTeam.team.player_count }} players
                    </p>
                  </div>

                  <div class="text-center">
                    <p class="text-xs uppercase tracking-[0.2em] text-white/60 mb-1">
                      Score
                    </p>
                    <div
                        :class="`score-${gameTeam.team.id}`"
                        class="inline-block px-4 py-1 rounded-full bg-black/40 border border-white/20 text-3xl font-extrabold text-transparent bg-clip-text bg-gradient-to-r from-yellow-300 via-amber-400 to-orange-500"
                    >
                      {{ gameTeam.score }}
                    </div>
                  </div>

                  <!-- Controls -->
                  <div class="flex flex-col gap-2">
                    <button
                        @click="updateScore(gameTeam.team.id, 1)"
                        class="w-10 h-10 flex items-center justify-center rounded-full bg-emerald-500 hover:bg-emerald-600 text-white text-2xl font-bold shadow-md hover:shadow-lg transition-all active:scale-95"
                    >
                      +
                    </button>
                    <button
                        @click="updateScore(gameTeam.team.id, -1)"
                        :disabled="gameTeam.score === 0"
                        class="w-10 h-10 flex items-center justify-center rounded-full bg-rose-500 hover:bg-rose-600 disabled:bg-rose-900/50 disabled:cursor-not-allowed text-white text-2xl font-bold shadow-md hover:shadow-lg transition-all active:scale-95"
                    >
                      −
                    </button>
                  </div>
                </div>
              </div>
            </div>

            <p
                v-if="!teams.length"
                class="text-center text-white/60 text-sm py-6"
            >
              Aucune équipe pour cette session.
            </p>
          </div>
        </div>

        <!-- PLAYLISTS TAB -->
        <div v-else-if="activeTab === 'playlists'" key="playlists">
          <div class="space-y-3">
            <div
                v-for="playlist in playlists"
                :key="playlist.id"
                class="bg-white/5 backdrop-blur-xl rounded-2xl p-4 border border-white/10 hover:border-white/40 transition-all shadow-md"
            >
              <div class="flex items-center justify-between gap-4">
                <div>
                  <h3 class="text-base font-semibold text-white">
                    {{ playlist.name }}
                  </h3>
                  <p class="text-xs text-white/60">
                    {{ playlist.nbTrack }} tracks
                  </p>
                </div>
                <div class="text-xs text-white/50 uppercase tracking-[0.2em]">
                  Playlist
                </div>
              </div>
            </div>

            <p
                v-if="!playlists.length"
                class="text-center text-white/60 text-sm py-6"
            >
              Aucune playlist associée à cette session.
            </p>
          </div>
        </div>

        <!-- INTERLUDES TAB -->
        <div v-else key="interludes">
          <div class="space-y-3">
            <div
                v-for="interlude in interludes"
                :key="interlude.id"
                class="bg-white/5 backdrop-blur-xl rounded-2xl p-4 border border-white/10 hover:border-white/40 transition-all shadow-md"
            >
              <div class="flex items-center justify-between gap-4">
                <div>
                  <h3 class="text-base font-semibold text-white">
                    {{ interlude.title }}
                  </h3>
                  <p class="text-xs text-white/60">
                    {{ interlude.lyrics }}
                  </p>
                </div>
                <div class="text-xs text-white/50 uppercase tracking-[0.2em]">
                  Interlude
                </div>
              </div>
            </div>

            <p
                v-if="!interludes.length"
                class="text-center text-white/60 text-sm py-6"
            >
              Aucun interlude pour cette session.
            </p>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>