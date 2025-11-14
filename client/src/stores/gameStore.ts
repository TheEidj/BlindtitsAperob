import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../services/api'
import type { Game } from '../types/game'

export type GameTab = 'teams' | 'playlists' | 'interludes'

export const useGameStore = defineStore('game', () => {
    const currentGame = ref<Game | null>(null)
    const currentGameTab = ref<GameTab>('teams')

    async function startGame(sessionId: number) {
        const response = await api.post(`/game/${sessionId}/start`)
        currentGame.value = response.data
    }

    async function endGame() {
        if (!currentGame.value) return
        await api.post(`/game/${currentGame.value.id}/end`)
        clearGame();
    }

    async function updateTeamScore(teamId: number, scoreDelta: number) {
        if (!currentGame.value) return

        try {
            const response = await api.post(
                `/game/${currentGame.value.id}/${teamId}/score`,
                { delta: scoreDelta }
            )

            currentGame.value = response.data
        } catch (error) {
            console.error('Failed to update score:', error)
            throw error
        }
    }

    function clearGame() {
        currentGame.value = null
    }

    function setGameTab(tab: GameTab) {
        currentGameTab.value = tab
    }

    return {
        currentGame,
        currentGameTab,
        startGame,
        endGame,
        updateTeamScore,
        setGameTab
    }
})