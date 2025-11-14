import type { Playlist } from './playlist';
import type { Team } from './team';
import type { Interlude } from './interlude';

export interface GameSession {
    id: number;
    number: number;
    date: string;
    status: string;
    teams?: Team[];
    playlists?: Playlist[];
    interludes?: Interlude[];
    teams_count?: number;
    playlists_count?: number;
    interludes_count?: number;
    created_at: string;
    updated_at?: string;
}
