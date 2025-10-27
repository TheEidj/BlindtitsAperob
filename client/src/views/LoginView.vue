<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";
import {useAuthStore} from "../stores/auth.ts";

const router = useRouter();
const authStore = useAuthStore();

const email = ref<string>("");
const password = ref<string>("");
const error = ref('');

const handleLogin = async () => {
  error.value = '';

  try {
    await authStore.login(email.value, password.value);
    router.push('/playlists');
  } catch (err: any) {
    error.value = err.response?.data?.error || 'Login failed';
    console.error('Login error:', err);
  }
};
</script>

<template>
  <div class="min-h-screen flex items-center justify-center bg-slate-900">
    <div class="bg-gray-800 p-8 w-80 rounded-lg shadow-lg min-w-[50vw]">
      <h1 class="text-3xl font-bold mb-6 text-center">BTAR Login</h1>

      <form @submit.prevent="handleLogin" class="space-y-4">
        <div>
          <label for="email" class="block text-sm font-medium mb-2">Email</label>
          <input
              id="email"
              v-model="email"
              type="email"
              required
              class="w-full px-4 py-2 bg-gray-700 rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none"
              placeholder="user@example.com"
          />
        </div>

        <div>
          <label for="password" class="block text-sm font-medium mb-2">Password</label>
          <input
              id="password"
              v-model="password"
              type="password"
              required
              class="w-full px-4 py-2 bg-gray-700 rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none"
              placeholder="••••••••"
          />
        </div>

        <div v-if="error" class="text-red-500 text-sm">
          {{ error }}
        </div>

        <button
            type="submit"
            :disabled="authStore.isLoading"
            class="w-full py-2 bg-indigo-600 hover:bg-indigo-700 rounded-lg font-semibold transition disabled:opacity-50 disabled:cursor-not-allowed"
        >
          {{ authStore.isLoading ? 'Logging in...' : 'Login' }}
        </button>
      </form>
    </div>
  </div>
</template>
