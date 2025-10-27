<script setup lang="ts">
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth.ts';

const router = useRouter();
const authStore = useAuthStore();

const handleLogout = () => {
  authStore.logout();
  router.push('/login');
};
</script>

<template>
  <div class="min-h-screen border-b border-gray-700 px-4 py-3 flex flex-col justify-center items-center gap-10">
    <div class="text-sm text-gray-400">
      {{ authStore.user?.email }}
    </div>
    <button
        @click="handleLogout"
        class="btn primary"
    >
      Logout
    </button>
  </div>
</template>