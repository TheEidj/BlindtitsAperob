import api from "./api";
import type { Playlist } from "../types/playlist";

export async function fetchPlaylists(): Promise<Playlist[]> {
    const res = await api.get<Playlist[]>("/playlists");
    return res.data;
}

export async function refreshPlaylists(): Promise<Playlist[]> {
    const res = await api.post<Playlist[]>("/playlists/refresh_all");
    return res.data;
}

export async function togglePlaylistPlayed(playlistId: number): Promise<Playlist> {
    const res = await api.patch<Playlist>(`/playlists/${playlistId}/toggle_played`);
    return res.data;
}

export async function fetchPlaylistDetail(playlistId: number): Promise<Playlist> {
    const res = await api.get<Playlist>(`/playlists/${playlistId}`);
    return res.data;
}

export async function fetchPlaylistOembed(playlistId: number): Promise<{ html: string }> {
    const res = await api.get<{ html: string }>(`/playlists/${playlistId}/oembed`);
    return res.data;
}

export async function archivePlaylist(playlistId: number): Promise<void> {
    await api.patch(`/playlists/${playlistId}/archive`);
}