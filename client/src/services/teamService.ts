import api from './api';
import type {Team} from "../types/team.ts";
import type {GameSession} from "../types/gameSession.ts";

export async function saveTeam(data: {
    id?: number
    gameSessionId: number
    teamName: string
    playerCount: number
}) {
    return data.id
        ? editTeam(data.id, data.gameSessionId, data.teamName, data.playerCount)
        : registerTeamForGameSession(data.gameSessionId, data.teamName, data.playerCount)
}
export const registerTeamForGameSession = async (
    gameSessionId: number,
    teamName: string,
    playerCount: number
): Promise<Team & { message: string }> => {
    const response = await api.post('/public/teams', {
        team: {
            name: teamName,
            player_count: playerCount,
        },
        game_session_id: gameSessionId
    });
    return response.data;
};

export const editTeam = async (
    teamId: number,
    gameSessionId: number,
    teamName: string,
    playerCount: number
): Promise<Team & { message: string }> => {
    const response = await api.patch(`/public/teams/${teamId}`, {
        team: {
            name: teamName,
            player_count: playerCount,
        },
        game_session_id: gameSessionId
    })
    return response.data;
}

export const removeTeamFromGameSession = async (
    gameSessionId: number,
    teamId: number
): Promise<GameSession> => {
    const response = await api.delete(`/game_sessions/${gameSessionId}/remove_team/${teamId}`);
    return response.data;
};