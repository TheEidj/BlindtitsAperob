import type { Playlist } from './playlist'
import type { Interlude } from './interlude'
import type { Team } from './team'

export interface GameTeam {
    team: Team
    score: number
    color: string | null
}

export interface Game {
    id: number
    number: number
    playlists: Playlist[]
    interludes: Interlude[]
    teams: GameTeam[]
}