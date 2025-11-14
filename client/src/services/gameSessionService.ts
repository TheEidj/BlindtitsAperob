import api from './api';
import type { GameSession } from '../types/gameSession';

export const fetchFeaturedGameSession = async (): Promise<GameSession | null> => {
    const response = await api.get('/public/game_sessions/featured');
    return response.data.id ? response.data : null;
};

export const fetchOngoingGameSession = async (): Promise<GameSession | null> => {
    const response = await api.get('/public/game_sessions/ongoing');
    return response.data.id ? response.data : null;
};

export const fetchUpcomingGameSession = async (): Promise<GameSession | null> => {
    const response = await api.get('/public/game_sessions/upcoming');
    return response.data.id ? response.data : null;
};

export const fetchArchivedGameSessions = async (): Promise<GameSession[]> => {
    const response = await api.get('/public/game_sessions/archived');
    return response.data;
};

export const fetchAllGameSessions = async (): Promise<GameSession[]> => {
    const response = await api.get('/game_sessions');
    return response.data;
};

export const fetchGameSessionDetail = async (id: number): Promise<GameSession> => {
    const response = await api.get(`/game_sessions/${id}`);
    return response.data;
};

export async function saveGameSession(data: {
    id?: number
    date: string
    status: string
    playerCount: number
}) {
    return data.id
        ? updateGameSession(data.id, data.date, data.status, data.playerCount)
        : createGameSession(data.date, data.status, data.playerCount)
}

export const createGameSession = async (date: string, status: string, number: number): Promise<GameSession> => {
    console.log('createGameSession', date, status, number);
    const response = await api.post('/game_sessions', {
        game_session: { date: date, status: status, number: number }
    });
    return response.data;
};

export const updateGameSession = async (id: number, date: string, status: string, number: number): Promise<GameSession> => {
    const response = await api.patch(`/game_sessions/${id}`, {
        game_session: { date: date, status: status, number: number }
    });
    return response.data;
};

export const deleteGameSession = async (id: number): Promise<void> => {
    await api.delete(`/game_sessions/${id}`);
};

export const addPlaylistToGameSession = async (
    gameSessionId: number,
    playlistId: number
): Promise<GameSession> => {
    const response = await api.post(`/game_sessions/${gameSessionId}/add_playlist`, {
        playlist_id: playlistId
    });
    return response.data;
};

export const removePlaylistFromGameSession = async (
    gameSessionId: number,
    playlistId: number
): Promise<GameSession> => {
    const response = await api.delete(`/game_sessions/${gameSessionId}/remove_playlist/${playlistId}`);
    return response.data;
};

export const reorderPlaylists = async (
    gameSessionId: number,
    playlistIds: number[]
): Promise<GameSession> => {
    const response = await api.patch(`/game_sessions/${gameSessionId}/reorder_playlists`, {
        playlist_ids: playlistIds
    });
    return response.data;
};