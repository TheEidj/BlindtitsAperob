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
    base: './',
    build: {
        outDir: 'dist',
        emptyOutDir: true,
    },
    server: {
        proxy: {
            '/api': {
                target: 'http://localhost:3000',
                changeOrigin: true,
            },
            '/auth': {
                target: 'http://localhost:3000',
                changeOrigin: true,
            },
            '/playlists': {
                target: 'http://localhost:3000',
                changeOrigin: true,
            },
            '/game_sessions': {
                target: 'http://localhost:3000',
                changeOrigin: true,
            },
            '/public': {
                target: 'http://localhost:3000',
                changeOrigin: true,
            },
        },
    },
})