import { createRouter, createWebHistory } from 'vue-router'
import type { RouteRecordRaw } from 'vue-router'
import { useAuthStore } from '../stores/auth';

import LoginView from '../views/LoginView.vue'
import ProfileView from '../views/ProfileView.vue'
import PlaylistsView from '../views/PlaylistsView.vue'
import PlaylistDetailView from '../views/PlaylistDetailView.vue'
import GameSessionsView from "../views/GameSessionsView.vue";
import GameSessionDetailView from "../views/GameSessionDetailView.vue";
import ArchivedGameSessionsView from "../views/ArchivedGameSessionsView.vue";
import InterludesView from "../views/InterludesView.vue";
import DashboardView from "../views/DashboardView.vue";
import GameView from "../views/GameView.vue";

const routes: Array<RouteRecordRaw> = [
    { path: '/', name: 'dashboard', component: DashboardView },
    { path: '/old-game-sessions', name: 'old-game-sessions', component: ArchivedGameSessionsView },
    { path: '/game-sessions/:id', name: 'game-session-detail', component: GameSessionDetailView },
    { path: '/login', name: 'login', component: LoginView },
    // Protected routes
    {
      path: '/game',
      name: 'game',
      component: GameView,
      meta: { requiresAuth: true }
    },
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
        path: '/interludes',
        name: 'interludes',
        component: InterludesView,
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
