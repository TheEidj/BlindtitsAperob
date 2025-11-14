<script setup lang="ts">
import type { Playlist } from "../../types/playlist";
import PlaylistBadge from "../atoms/PlaylistBadge.vue";
import {useSwipeNavigate} from "../../composables/useSwipeNavigate.ts";

const props = defineProps<{ 
  playlist: Playlist;
}>();

const { cardRef, onClick } = useSwipeNavigate(`/playlists/${props.playlist.id}`);
</script>

<template>
  <div
      ref="cardRef"
      @click="onClick"
      class="card bg-gray-800 border border-gray-700 rounded-lg p-4 hover:border-indigo-500 transition-colors cursor-pointer select-none touch-none"
  >
    <div class="flex items-center justify-between">
      <div class="flex-1 pointer-events-none">
        <div class="text-lg font-semibold">{{ playlist.name }}</div>
        <div class="flex items-center gap-3 mt-1">
          <PlaylistBadge
              :isMine="playlist.is_mine"
              :isFollowed="playlist.is_followed"
              :nbTrack="playlist.nbTrack"
              :isCollaborative="playlist.is_collaborative"
          />
        </div>
      </div>
      
      <!-- Indicateur visuel -->
      <div class="text-indigo-400 text-2xl opacity-60 pointer-events-none">
        →
      </div>
    </div>
  </div>
</template>
