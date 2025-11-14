import api from './api';
import type { Interlude } from '../types/interlude';
import type { GameSession } from '../types/gameSession';

export async function saveInterlude(data: {
    id?: number;
    title: string;
    lyrics: string;
    done?: boolean;
}): Promise<Interlude> {
    return data.id
        ? editInterlude(data.id, data.title, data.lyrics, data.done)
        : createInterlude(data.title, data.lyrics, data.done);
}

export const createInterlude = async (
    title: string,
    lyrics: string,
    done: boolean = false
): Promise<Interlude> => {
    const response = await api.post('/interludes', {
        interlude: {
            title,
            lyrics,
            done,
        },
    });
    return response.data;
};

export const editInterlude = async (
    interludeId: number,
    title: string,
    lyrics: string,
    done?: boolean
): Promise<Interlude> => {
    const response = await api.patch(`/interludes/${interludeId}`, {
        interlude: {
            title,
            lyrics,
            done,
        },
    });
    return response.data;
};

export const getInterludes = async (): Promise<Interlude[]> => {
    const response = await api.get('/interludes');
    return response.data;
};

export const getInterlude = async (id: number): Promise<Interlude> => {
    const response = await api.get(`/interludes/${id}`);
    return response.data;
};

export const deleteInterlude = async (id: number): Promise<void> => {
    await api.delete(`/interludes/${id}`);
};

export const addInterludeToGameSession = async (
    gameSessionId: number,
    interludeId: number
): Promise<GameSession> => {
    const response = await api.post(`/game_sessions/${gameSessionId}/add_interlude`, {
        interlude_id: interludeId,
    });
    return response.data;
};

export const removeInterludeFromGameSession = async (
    gameSessionId: number,
    interludeId: number
): Promise<GameSession> => {
    const response = await api.delete(`/game_sessions/${gameSessionId}/remove_interlude/${interludeId}`);
    return response.data;
};

export const reorderInterludes = async (
    gameSessionId: number,
    interludeIds: number[]
): Promise<GameSession> => {
    const response = await api.patch(`/game_sessions/${gameSessionId}/reorder_interludes`, {
        interlude_ids: interludeIds
    });
    return response.data;
};