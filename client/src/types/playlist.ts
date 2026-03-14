export interface Playlist {
    id: number;
    name: string;
    deezer_id: string;
    deezer_creator_id: string;
    url: string;
    nbTrack: number;
    is_mine: boolean;
    is_followed: boolean;
    played: boolean;
    is_collaborative: boolean;
    creator_name?: string;
}
