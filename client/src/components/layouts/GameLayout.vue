<script setup lang="ts">
import GameNav from '../organisms/GameNav.vue';
</script>

<template>
  <div class="pt-10 pb-30 px-4 bg-gradient min-h-screen">
    <slot />
    <GameNav/>
  </div>
</template>