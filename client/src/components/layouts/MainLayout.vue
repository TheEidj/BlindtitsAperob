<script setup lang="ts">
import { computed } from 'vue';
import { useAuthStore } from "../../stores/auth";
import AdminNav from '../organisms/AdminNav.vue';
import VisitorNav from "../organisms/VisitorNav.vue";

const authStore = useAuthStore();

const isAdmin = computed(() => {
  return authStore.isAuthenticated;
});
</script>

<template>
  <div class="pt-10 pb-30 px-4 bg-gradient min-h-screen">
    <slot />
    <AdminNav v-if="isAdmin"/>
    <VisitorNav v-else/>
  </div>
</template>