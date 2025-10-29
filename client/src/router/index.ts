import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { useAuthStore } from '../stores/auth';

import LoginView from '../views/LoginView.vue'
import ProfileView from '../views/ProfileView.vue'
import PlaylistsView from '../views/PlaylistsView.vue'
import PlaylistDetailView from '../views/PlaylistDetailView.vue'
import GameSessionAdminDetailView from "../views/GameSessionAdminDetailView.vue";
import LandingView from "../views/LandingView.vue";
import GameSessionsView from "../views/GameSessionsView.vue";
import GameSessionDetailView from "../views/GameSessionDetailView.vue";
import OldGameSessionsListView from "../views/OldGameSessionsView.vue";

const routes: Array<RouteRecordRaw> = [
    { path: '/', name: 'landing', component: LandingView },
    { path: '/old-game-sessions', name: 'old-game-sessions', component: OldGameSessionsListView },
    { path: '/game-sessions/:id', name: 'game-session-detail', component: GameSessionDetailView },
    { path: '/login', name: 'login', component: LoginView },
    {
        path: '/profile',
        name: 'profile',
        component: ProfileView,
        meta: { requiresAuth: true }
    },
    {
        path: '/playlists',
        name: 'playlists',
        component: PlaylistsView,
        meta: { requiresAuth: true }
    },
    {
        path: '/playlists/:id',
        name: 'playlist-detail',
        component: PlaylistDetailView,
        meta: { requiresAuth: true }
    },
    {
        path: '/game-sessions',
        name: 'game-sessions',
        component: GameSessionsView,
        meta: { requiresAuth: true }
    },
    {
        path: '/game-sessions/:id/admin',
        name: 'game-session-admin-detail',
        component: GameSessionAdminDetailView,
        meta: { requiresAuth: true }
    },
]

const router = createRouter({
    history: createWebHistory('/'),
    routes,
})

router.beforeEach((to, _from, next): void => {
    const authStore = useAuthStore();

    if (to.meta.requiresAuth && !authStore.isAuthenticated) {
        return next("/login");
    }

    if (to.path === "/login" && authStore.isAuthenticated) {
        return next("/");
    }

    next();
});

export default router
