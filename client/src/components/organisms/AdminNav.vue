<script setup lang="ts">
import NavItem from '../molecules/NavItem.vue';
import {
  MusicalNoteIcon,
  PlayIcon,
  MicrophoneIcon,
  HomeModernIcon
} from '@heroicons/vue/24/outline';

const navItems = [
  { to: '/', label: 'Dashboard', icon: HomeModernIcon },
  { to: '/playlists', label: 'Playlists', icon: MusicalNoteIcon },
  { to: '/interludes', label: 'Interludes', icon: MicrophoneIcon },
  { to: '/game-sessions', label: 'Games', icon: PlayIcon },
];
</script>

<template>
  <nav class="fixed rounded-full bg-white/50 backdrop-blur-sm mx-4 mb-5 bottom-0 left-0 right-0 shadow-lg z-50">
    <div class="max-w-full">
      <div class="flex justify-around items-center">
        <NavItem
            v-for="item in navItems"
            :key="item.to"
            :to="item.to"
            :label="item.label"
            :icon="item.icon"
        />
      </div>
    </div>
  </nav>
</template>