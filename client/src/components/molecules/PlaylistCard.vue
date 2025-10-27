<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";
import { useRouter } from "vue-router";
import {animate, spring } from "animejs";
import type { Playlist } from "../../types/playlist";
import PlaylistBadge from "../atoms/PlaylistBadge.vue";

const props = defineProps<{ 
  playlist: Playlist;
}>();

const router = useRouter();
const cardRef = ref<HTMLDivElement | null>(null);

let startX = 0;
let currentX = 0;
let isDragging = false;
let currentAnimation: any = null;
const SWIPE_THRESHOLD = 80;

const handleStart = (clientX: number) => {

  if (currentAnimation) {
    currentAnimation.pause();
    currentAnimation = null;
  }

  startX = clientX;
  currentX = 0;
  isDragging = true;
};

const handleMove = (clientX: number) => {
  if (!isDragging || !cardRef.value) return;
  
  currentX = clientX - startX;

  if (currentX > 0) {
    const rubberBand = currentX > 200 ? 200 + (currentX - 200) * 0.3 : currentX;
    cardRef.value.style.transform = `translateX(${rubberBand}px)`;
    cardRef.value.style.opacity = `${Math.max(0.3, 1 - currentX / 300)}`;
  } else {
    const rubberBandLeft = currentX < -100 ? -100 + (currentX + 100) * 0.2 : currentX;
    cardRef.value.style.transform = `translateX(${rubberBandLeft}px)`;
    cardRef.value.style.opacity = `${Math.max(0.7, 1 + currentX / 300)}`;
  }
};

const handleEnd = () => {
  if (!isDragging || !cardRef.value) return;
  
  isDragging = false;
  
  if (currentX > SWIPE_THRESHOLD) {
    // Swipe suffisant
    currentAnimation = animate(cardRef.value, {
      translateX: ['', window.innerWidth + 'px'],
      opacity: 0,
      duration: 300,
      complete: () => {
        currentAnimation = null;
        router.push(`/playlists/${props.playlist.id}`);
      }
    });
  } else {
    // Revenir à la position initiale
    currentAnimation = animate(cardRef.value, {
      x: 0,
      opacity: 1,
      duration: 400,
      ease: spring({
        bounce: .6,
        stiffness: 300,
        damping: 25,
      }),
      complete: () => {
        currentAnimation = null;
      }
    });
  }
};

// Touch handlers
const onTouchStart = (e: TouchEvent) => {
  const touch = e.touches?.[0];
  if (touch) handleStart(touch.clientX);
};

const onTouchMove = (e: TouchEvent) => {
  const touch = e.touches?.[0];
  if (touch) handleMove(touch.clientX);
};

const onTouchEnd = () => {
  handleEnd();
};

// Mouse handlers
const onMouseDown = (e: MouseEvent) => {
  handleStart(e.clientX);
  e.preventDefault();
};

const onMouseMove = (e: MouseEvent) => {
  handleMove(e.clientX);
};

const onMouseUp = () => {
  handleEnd();
};

const onClick = (e: MouseEvent) => {
  // Empêcher le click si on a dragué
  if (Math.abs(currentX) > 5) {
    e.preventDefault();
    e.stopPropagation();
    return;
  }
  
  router.push(`/playlists/${props.playlist.id}`);
};

onMounted(() => {
  const card = cardRef.value;
  if (!card) return;
  
  // Touch events
  card.addEventListener('touchstart', onTouchStart, { passive: true });
  card.addEventListener('touchmove', onTouchMove, { passive: true });
  card.addEventListener('touchend', onTouchEnd);
  
  // Mouse events
  card.addEventListener('mousedown', onMouseDown);
  document.addEventListener('mousemove', onMouseMove);
  document.addEventListener('mouseup', onMouseUp);
});

onUnmounted(() => {
  const card = cardRef.value;
  if (!card) return;
  
  // Cleanup
  card.removeEventListener('touchstart', onTouchStart);
  card.removeEventListener('touchmove', onTouchMove);
  card.removeEventListener('touchend', onTouchEnd);
  card.removeEventListener('mousedown', onMouseDown);
  document.removeEventListener('mousemove', onMouseMove);
  document.removeEventListener('mouseup', onMouseUp);
});
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
      <div class="text-indigo-500 text-2xl opacity-30 pointer-events-none">
        →
      </div>
    </div>
  </div>
</template>
