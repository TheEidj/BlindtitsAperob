import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { useAuthStore } from '../stores/auth';

import LoginView from '../views/LoginView.vue'
import ProfileView from '../views/ProfileView.vue'
import PlaylistsView from '../views/PlaylistsView.vue'
import PlaylistDetailView from '../views/PlaylistDetailView.vue'

const routes: Array<RouteRecordRaw> = [
    { path: '/', redirect: '/login' },
    { path: '/login', name: 'login', component: LoginView },
    { path: '/profile', name: 'profile', component: ProfileView },
    { path: '/playlists', name: 'playlists', component: PlaylistsView },
    { path: '/playlists/:id', name: 'playlist-detail', component: PlaylistDetailView },
]

const router = createRouter({
    history: createWebHistory(),
    routes,
})

router.beforeEach((to, _from, next): void => {
    const authStore = useAuthStore();

    if (to.path !== "/login" && !authStore.isAuthenticated) {
        // pas de token -> redirection vers login
        return next("/login");
    }

    if (to.path === "/login" && authStore.isAuthenticated) {
        // déjà logged -> éviter retour inutile au login
        return next("/playlists");
    }

    next();
});

export default router
