<script setup lang="ts">
import { useRoute } from 'vue-router';
import { ref, onMounted, computed } from "vue";
import MainLayout from "./components/layouts/MainLayout.vue";
import GameLayout from "./components/layouts/GameLayout.vue";
import {useAuthStore} from "./stores/auth.ts";

const isBootstrapping = ref(true);
const route = useRoute();
const authStore = useAuthStore();

const GameLayoutPages = ['/game'];
const shouldShowGameLayout = computed(() => GameLayoutPages.includes(route.path));

onMounted(async () => {
  isBootstrapping.value = false;
  authStore.initAuth();
});
</script>

<template>
  <div class="min-h-screen bg-gray-900 text-gray-100">
    <transition name="fade">
      <div v-if="isBootstrapping" class="flex items-center justify-center h-screen">
        <div class="text-center animate-pulse">
          <h1 class="text-2xl font-bold">Chargement...</h1>
        </div>
      </div>
      <div v-else class="container mx-auto max-w-xl">
        <GameLayout v-if="shouldShowGameLayout">
          <RouterView />
        </GameLayout>
        <MainLayout v-else>
          <RouterView/>
        </MainLayout>
      </div>
    </transition>
  </div>
</template>
