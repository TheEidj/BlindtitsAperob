import type { Playlist } from './playlist';
import type { Team } from './team';

export interface GameSession {
    id: number;
    date: string;
    teams?: Team[];
    playlists?: Playlist[];
    teams_count?: number;
    playlists_count?: number;
    upcoming?: boolean;
    created_at: string;
    updated_at?: string;
}