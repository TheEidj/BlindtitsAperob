<script setup lang="ts">
import type { Playlist } from "../../types/playlist";
import PlaylistBadge from "../atoms/PlaylistBadge.vue";
import {useSwipeNavigate} from "../../composables/useSwipeNavigate.ts";
import {archivePlaylist} from "../../services/playlistService.ts";
import {computed, ref} from "vue";

const props = defineProps<{
  playlist: Playlist;
}>();

const emit = defineEmits<{
  archived: [id: number]
}>();

const handleArchive = async () => {
  await archivePlaylist(props.playlist.id);
  emit('archived', props.playlist.id);
};

const { cardRef, onClick, getSwipeDirection } = useSwipeNavigate(`/playlists/${props.playlist.id}`, handleArchive);

const swipeDirection = ref<'left' | 'right' | null>(null);

// Surveiller la direction du swipe
const checkSwipe = () => {
  swipeDirection.value = getSwipeDirection();
  requestAnimationFrame(checkSwipe);
};
checkSwipe();

const borderClass = computed(() => {
  if (!props.playlist.is_followed) {
    return 'border-red-500';
  }
  return 'border-gray-700';
});
</script>

<template>
  <div class="relative">
    <div
        ref="cardRef"
        @click="onClick"
        :class="['card bg-gray-800 border-2 rounded-lg p-4 hover:border-indigo-500 transition-colors cursor-pointer', borderClass]"
    >
      <div class="flex items-center justify-between">
        <div class="flex-1">
          <div class="text-lg font-semibold">{{ playlist.name }}</div>
          <div class="flex items-center gap-3 mt-1">
            <PlaylistBadge
                :isMine="playlist.is_mine"
                :isFollowed="playlist.is_followed"
                :nbTrack="playlist.nbTrack"
                :isCollaborative="playlist.is_collaborative"
                :creatorName="playlist.creator_name"
            />
          </div>
        </div>

        <!-- Indicateur visuel dynamique -->
        <div v-if="!swipeDirection" class="text-indigo-400 text-2xl opacity-60">
          →
        </div>
        <div v-else-if="swipeDirection === 'right'" class="text-green-400 text-2xl">
          👁️
        </div>
        <div v-else-if="swipeDirection === 'left'" class="text-red-400 text-2xl">
          🗄️
        </div>
      </div>
    </div>
  </div>
</template>
