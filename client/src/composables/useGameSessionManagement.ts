import { ref } from 'vue';
import type { GameSession } from '../types/gameSession';
import type { Playlist } from '../types/playlist';
import type { Interlude } from '../types/interlude';
import {
    fetchGameSessionDetail,
    addPlaylistToGameSession,
    removePlaylistFromGameSession,
    reorderPlaylists,
    deleteGameSession,
} from '../services/gameSessionService';
import {
    getInterludes,
    addInterludeToGameSession,
    removeInterludeFromGameSession,
    reorderInterludes,
} from '../services/interludeService';
import { removeTeamFromGameSession } from '../services/teamService';
import { fetchPlaylists } from '../services/playlistService';

export function useGameSessionManagement(gameSessionId: number) {
    const gameSession = ref<GameSession | undefined>(undefined);
    const availablePlaylists = ref<Playlist[]>([]);
    const availableInterludes = ref<Interlude[]>([]);
    const isLoading = ref(true);

    const loadGameSession = async () => {
        isLoading.value = true;
        try {
            gameSession.value = await fetchGameSessionDetail(gameSessionId);
            availablePlaylists.value = await fetchPlaylists();
            availableInterludes.value = await getInterludes();
        } catch (error) {
            console.error('Error loading game session:', error);
            throw error;
        } finally {
            isLoading.value = false;
        }
    };

    // Teams
    const handleRemoveTeam = async (teamId: number) => {
        if (!gameSession.value || !confirm('Remove this team?')) return;
        try {
            gameSession.value = await removeTeamFromGameSession(gameSession.value.id, teamId);
        } catch (error) {
            console.error('Error removing team:', error);
        }
    };

    // Playlists
    const handleAddPlaylist = async (playlistId: number) => {
        if (!gameSession.value) return;
        try {
            gameSession.value = await addPlaylistToGameSession(gameSession.value.id, playlistId);
            return true;
        } catch (error) {
            console.error('Error adding playlist:', error);
            return false;
        }
    };

    const handleRemovePlaylist = async (playlistId: number) => {
        if (!gameSession.value || !confirm('Remove this playlist?')) return;
        try {
            gameSession.value = await removePlaylistFromGameSession(gameSession.value.id, playlistId);
        } catch (error) {
            console.error('Error removing playlist:', error);
        }
    };

    const handleReorderPlaylists = async (fromId: number, toId: number) => {
        if (!gameSession.value) return;
        const playlists = gameSession.value.playlists || [];
        const fromIndex = playlists.findIndex((p) => p.id === fromId);
        const toIndex = playlists.findIndex((p) => p.id === toId);

        if (fromIndex === -1 || toIndex === -1) return;

        const reordered = [...playlists];
        const [removed] = reordered.splice(fromIndex, 1);
        if (removed) reordered.splice(toIndex, 0, removed);

        try {
            gameSession.value = await reorderPlaylists(
                gameSession.value.id,
                reordered.map((p) => p.id)
            );
        } catch (error) {
            console.error('Error reordering playlists:', error);
        }
    };

    // Interludes
    const handleAddInterlude = async (interludeId: number) => {
        if (!gameSession.value) return;
        try {
            gameSession.value = await addInterludeToGameSession(gameSession.value.id, interludeId);
            return true;
        } catch (error) {
            console.error('Error adding interlude:', error);
            return false;
        }
    };

    const handleRemoveInterlude = async (interludeId: number) => {
        if (!gameSession.value || !confirm('Remove this interlude?')) return;
        try {
            gameSession.value = await removeInterludeFromGameSession(gameSession.value.id, interludeId);
        } catch (error) {
            console.error('Error removing interlude:', error);
        }
    };

    const handleReorderInterludes = async (fromId: number, toId: number) => {
        if (!gameSession.value) return;
        const interludes = gameSession.value.interludes || [];
        const fromIndex = interludes.findIndex((i) => i.id === fromId);
        const toIndex = interludes.findIndex((i) => i.id === toId);

        if (fromIndex === -1 || toIndex === -1) return;

        const reordered = [...interludes];
        const [removed] = reordered.splice(fromIndex, 1);
        if (removed) reordered.splice(toIndex, 0, removed);

        try {
            gameSession.value = await reorderInterludes(
                gameSession.value.id,
                reordered.map((i) => i.id)
            );
        } catch (error) {
            console.error('Error reordering interludes:', error);
        }
    };

    const handleDeleteSession = async () => {
        if (!gameSession.value || !confirm('Delete this game session? This cannot be undone.')) return false;
        try {
            await deleteGameSession(gameSession.value.id);
            return true;
        } catch (error) {
            console.error('Error deleting session:', error);
            return false;
        }
    };

    return {
        gameSession,
        availablePlaylists,
        availableInterludes,
        isLoading,
        loadGameSession,
        // Teams
        handleRemoveTeam,
        // Playlists
        handleAddPlaylist,
        handleRemovePlaylist,
        handleReorderPlaylists,
        // Interludes
        handleAddInterlude,
        handleRemoveInterlude,
        handleReorderInterludes,
        // Session
        handleDeleteSession,
    };
}