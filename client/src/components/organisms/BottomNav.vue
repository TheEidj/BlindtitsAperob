<script setup lang="ts">
import NavItem from '../molecules/NavItem.vue';
import {
  MusicalNoteIcon,
  PlayIcon,
  UserGroupIcon,
  UserCircleIcon
} from '@heroicons/vue/24/outline';

const navItems = [
  { to: '/playlists', label: 'Playlists', icon: MusicalNoteIcon },
  { to: '/game-sessions', label: 'Games', icon: PlayIcon },
  { to: '/teams', label: 'Teams', icon: UserGroupIcon },
  { to: '/profile', label: 'Profile', icon: UserCircleIcon },
];
</script>

<template>
  <nav class="fixed bottom-0 left-0 right-0 bg-gray-900 border-t border-gray-800 shadow-lg z-50">
    <div class="max-w-screen-xl mx-auto px-4">
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