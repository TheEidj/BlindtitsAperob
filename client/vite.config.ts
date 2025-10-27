import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
    plugins: [
        vue(),
        tailwindcss()
    ],
    resolve: {
        alias: {
            '@': fileURLToPath(new URL('./src', import.meta.url))
        }
    },
    base: '/app/',
    build: {
        outDir: 'dist',
        emptyOutDir: true,
    },
    server: {
        port: 5173,
        proxy: {
            '/login': 'http://localhost:3000',
            '/me': 'http://localhost:3000',
            '/playlists': 'http://localhost:3000',
            '/teams': 'http://localhost:3000',
            '/game_sessions': 'http://localhost:3000',
            '/tracks': 'http://localhost:3000',
        }
    }
})