import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import api from '../services/api';

interface User {
    id: number;
    email: string;
    role: string;
    deezer_id?: number;
}

interface LoginResponse {
    token: string;
    user: User;
}

export const useAuthStore = defineStore('auth', () => {
    // State
    const token = ref<string | null>(localStorage.getItem('token'));
    const user = ref<User | null>(null);
    const isLoading = ref(false);

    // Getters
    const isAuthenticated = computed(() => !!token.value);

    // Actions
    const login = async (email: string, password: string): Promise<void> => {
        isLoading.value = true;
        try {
            const response = await api.post<LoginResponse>('/login', { email, password });

            token.value = response.data.token;
            user.value = response.data.user;

            // Sauvegarder dans localStorage
            localStorage.setItem('token', response.data.token);

            // Configurer le header pour toutes les futures requêtes
            api.defaults.headers.common['Authorization'] = `Bearer ${response.data.token}`;

            console.log('✅ Login successful, token saved');
        } catch (error) {
            console.error('❌ Login failed:', error);
            throw error;
        } finally {
            isLoading.value = false;
        }
    };

    const logout = (): void => {
        token.value = null;
        user.value = null;
        localStorage.removeItem('token');
        delete api.defaults.headers.common['Authorization'];
        console.log('✅ Logged out');
    };

    const fetchCurrentUser = async (): Promise<void> => {
        if (!token.value) return;

        try {
            const response = await api.get<User>('/me');
            user.value = response.data;
        } catch (error) {
            console.error('❌ Failed to fetch current user:', error);
            // Si le token est invalide, logout
            logout();
        }
    };

    const initAuth = (): void => {
        const savedToken = localStorage.getItem('token');
        if (savedToken) {
            token.value = savedToken;
            api.defaults.headers.common['Authorization'] = `Bearer ${savedToken}`;
            fetchCurrentUser();
        }
    };

    return {
        // State
        token,
        user,
        isLoading,
        // Getters
        isAuthenticated,
        // Actions
        login,
        logout,
        fetchCurrentUser,
        initAuth,
    };
});