<script setup lang="ts">
import { useRoute } from 'vue-router';
import { ref, onMounted, computed } from "vue";
import MainLayout from "./components/layouts/MainLayout.vue";
import {useAuthStore} from "./stores/auth.ts";

const isBootstrapping = ref(true);
const route = useRoute();
const authStore = useAuthStore();

// Pages qui n'ont pas besoin du layout (ex: login)
const noLayoutPages = ['/login'];
const shouldShowLayout = computed(() => !noLayoutPages.includes(route.path));

onMounted(async () => {
  isBootstrapping.value = false;
  authStore.initAuth();
});
</script>

<template>
  <div class="min--h-screen bg-gray-900 text-gray-100">
    <transition name="fade">
      <div v-if="isBootstrapping" class="flex items-center justify-center h-screen">
        <div class="text-center animate-pulse">
          <h1 class="text-2xl font-bold">Chargement...</h1>
        </div>
      </div>
      <div v-else class="container mx-auto">
        <MainLayout v-if="shouldShowLayout">
          <RouterView />
        </MainLayout>
        <RouterView v-else />
      </div>
    </transition>
  </div>
</template>


<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.25s;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
