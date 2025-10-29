<script setup lang="ts">
import { ref } from "vue";
import { useRouter } from "vue-router";
import {useAuthStore} from "../stores/auth.ts";
import { ArrowLeftIcon } from '@heroicons/vue/24/outline';

const router = useRouter();
const authStore = useAuthStore();

const email = ref('');
const password = ref('');
const error = ref('');
const isLoading = ref(false);

const handleLogin = async () => {
  error.value = '';
  isLoading.value = true;

  try {
    await authStore.login(email.value, password.value);
    await router.push('/playlists');
  } catch (err: any) {
    error.value = err.response?.data?.error || 'Login failed';
  } finally {
    isLoading.value = false;
  }
};

const goBack = () => {
  router.push('/');
};
</script>

<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-900 via-indigo-900 to-purple-900 flex items-center justify-center p-6">
    <div class="w-full max-w-md">
      <button
          @click="goBack"
          class="mb-6 p-2 rounded-full bg-gray-800 hover:bg-gray-700 transition-colors"
      >
        <ArrowLeftIcon class="h-6 w-6 text-white" />
      </button>

      <div class="bg-gray-800 rounded-2xl p-8 shadow-2xl">
        <h1 class="text-3xl font-bold text-white mb-8 text-center">Admin Login</h1>

        <form @submit.prevent="handleLogin" class="space-y-6">
          <div>
            <label class="block text-white font-medium mb-2">Email</label>
            <input
                v-model="email"
                type="email"
                required
                class="w-full px-4 py-3 rounded-lg bg-gray-700 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
                placeholder="Enter your email"
            />
          </div>

          <div>
            <label class="block text-white font-medium mb-2">Password</label>
            <input
                v-model="password"
                type="password"
                required
                class="w-full px-4 py-3 rounded-lg bg-gray-700 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
                placeholder="Enter your password"
            />
          </div>

          <div v-if="error" class="bg-red-500/20 border border-red-500 text-red-400 px-4 py-3 rounded-lg">
            {{ error }}
          </div>

          <button
              type="submit"
              :disabled="isLoading"
              class="w-full bg-indigo-600 text-white py-3 rounded-lg font-bold hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            {{ isLoading ? 'Logging in...' : 'Login' }}
          </button>
        </form>
      </div>
    </div>
  </div>
</template>
