<script setup lang="ts">
import BottomNav from '../organisms/BottomNav.vue';
</script>

<template>
  <div class="min-h-screen bg-slate-900 text-white pb-20">
    <!-- pb-20 pour laisser l'espace pour la bottom nav -->
    <main class="container mx-auto">
      <slot />
    </main>
    <BottomNav />
  </div>
</template>