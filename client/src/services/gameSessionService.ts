import api from './api';
import type { GameSession } from '../types/gameSession';
import type { Team } from '../types/team';

export const fetchUpcomingGameSession = async (): Promise<GameSession | null> => {
    const response = await api.get('/public/game_sessions/upcoming');
    return response.data.id ? response.data : null;
};

export const fetchPastGameSessions = async (): Promise<GameSession[]> => {
    const response = await api.get('/public/game_sessions/past');
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

export const createGameSession = async (date: string): Promise<GameSession> => {
    const response = await api.post('/game_sessions', {
        game_session: { scheduled_at: date }
    });
    return response.data;
};

export const updateGameSession = async (id: number, date: string): Promise<GameSession> => {
    const response = await api.patch(`/game_sessions/${id}`, {
        game_session: { scheduled_at: date }
    });
    return response.data;
};

export const deleteGameSession = async (id: number): Promise<void> => {
    await api.delete(`/game_sessions/${id}`);
};

export const registerTeam = async (
    gameSessionId: number,
    teamName: string,
    playerCount: number
): Promise<Team & { message: string }> => {
    const response = await api.post('/public/teams', {
        team: {
            name: teamName,
            player_count: playerCount,
            game_session_id: gameSessionId
        }
    });
    return response.data;
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

export const removeTeamFromGameSession = async (
    gameSessionId: number,
    teamId: number
): Promise<GameSession> => {
    const response = await api.delete(`/game_sessions/${gameSessionId}/remove_team/${teamId}`);
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