<script setup lang="ts">
import { computed } from 'vue';
import { useAuthStore } from "../../stores/auth";
import BottomNav from '../organisms/BottomNav.vue';
import VisitorNav from "../organisms/VisitorNav.vue";

const authStore = useAuthStore();

const showAdminNav = computed(() => {
  return authStore.isAuthenticated;
});
</script>

<template>
  <div class="min-h-screen bg-slate-900 text-white pb-20">
    <!-- pb-20 pour laisser l'espace pour la bottom nav -->
    <main class="container mx-auto">
      <slot />
    </main>
    <BottomNav v-if="showAdminNav"/>
    <VisitorNav v-else/>
  </div>
</template>