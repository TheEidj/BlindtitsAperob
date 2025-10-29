<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import type { GameSession } from '../types/gameSession';
import type { Playlist } from '../types/playlist';
import {
  fetchGameSessionDetail,
  removeTeamFromGameSession,
  addPlaylistToGameSession,
  removePlaylistFromGameSession,
  reorderPlaylists,
  updateGameSession,
  deleteGameSession
} from '../services/gameSessionService';
import { fetchPlaylists } from '../services/playlistService';
import {
  ArrowLeftIcon,
  UserGroupIcon,
  MusicalNoteIcon,
  TrashIcon,
  PlusIcon,
  PencilIcon
} from '@heroicons/vue/24/outline';
import { animate } from 'animejs';

const route = useRoute();
const router = useRouter();
const gameSession = ref<GameSession | null>(null);
const availablePlaylists = ref<Playlist[]>([]);
const isLoading = ref(true);
const showPlaylistModal = ref(false);
const showEditModal = ref(false);
const editedDate = ref('');
const draggedPlaylistId = ref<number | null>(null);

const loadGameSession = async () => {
  isLoading.value = true;
  try {
    const id = Number(route.params.id);
    gameSession.value = await fetchGameSessionDetail(id);
    availablePlaylists.value = await fetchPlaylists();

    animate({
      targets: '.admin-section',
      opacity: [0, 1],
      translateY: [20, 0],
      delay: anime.stagger(100),
      duration: 600,
      easing: 'easeOutCubic'
    });
  } catch (error) {
    console.error('Error loading game session:', error);
  } finally {
    isLoading.value = false;
  }
};

const handleRemoveTeam = async (teamId: number) => {
  if (!gameSession.value || !confirm('Remove this team?')) return;

  try {
    gameSession.value = await removeTeamFromGameSession(gameSession.value.id, teamId);
  } catch (error) {
    console.error('Error removing team:', error);
  }
};

const handleAddPlaylist = async (playlistId: number) => {
  if (!gameSession.value) return;

  try {
    gameSession.value = await addPlaylistToGameSession(gameSession.value.id, playlistId);
    showPlaylistModal.value = false;
  } catch (error) {
    console.error('Error adding playlist:', error);
  }
};

const handleRemovePlaylist = async (playlistId: number) => {
  if (!gameSession.value || !confirm('Remove this playlist?')) return;

  try {
    gameSession.value = await removePlaylistFromGameSession(gameSession.value.id, playlistId);
  } catch (error) {
    console.error('Error removing playlist:', error);
  }
};

const handleDragStart = (playlistId: number) => {
  draggedPlaylistId.value = playlistId;
};

const handleDrop = async (targetPlaylistId: number) => {
  if (!gameSession.value || !draggedPlaylistId.value) return;

  const playlists = gameSession.value.playlists || [];
  const draggedIndex = playlists.findIndex(p => p.id === draggedPlaylistId.value);
  const targetIndex = playlists.findIndex(p => p.id === targetPlaylistId);

  if (draggedIndex === -1 || targetIndex === -1) return;

  const reordered = [...playlists];
  const [removed] = reordered.splice(draggedIndex, 1);
  reordered.splice(targetIndex, 0, removed);

  try {
    gameSession.value = await reorderPlaylists(
        gameSession.value.id,
        reordered.map(p => p.id)
    );
  } catch (error) {
    console.error('Error reordering playlists:', error);
  }

  draggedPlaylistId.value = null;
};

const openEditModal = () => {
  if (!gameSession.value) return;
  editedDate.value = new Date(gameSession.value.date).toISOString().slice(0, 16);
  showEditModal.value = true;
};

const handleUpdateSession = async () => {
  if (!gameSession.value || !editedDate.value) return;

  try {
    gameSession.value = await updateGameSession(gameSession.value.id, editedDate.value);
    showEditModal.value = false;
  } catch (error) {
    console.error('Error updating session:', error);
  }
};

const handleDeleteSession = async () => {
  if (!gameSession.value || !confirm('Delete this game session? This cannot be undone.')) return;

  try {
    await deleteGameSession(gameSession.value.id);
    router.push('/game-sessions');
  } catch (error) {
    console.error('Error deleting session:', error);
  }
};

const formatDate = (dateString: string) => {
  const date = new Date(dateString);
  return date.toLocaleDateString('fr-FR', {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  });
};

const goBack = () => {
  router.push('/game-sessions');
};

onMounted(loadGameSession);
</script>

<template>
  <div class="min-h-screen bg-gray-900 p-6 pb-24">
    <div class="max-w-4xl mx-auto">
      <div class="flex items-center justify-between mb-6">
        <button
            @click="goBack"
            class="p-2 rounded-full bg-gray-800 hover:bg-gray-700 transition-colors"
        >
          <ArrowLeftIcon class="h-6 w-6 text-white" />
        </button>

        <div class="flex gap-2">
          <button
              @click="openEditModal"
              class="p-2 rounded-full bg-indigo-600 hover:bg-indigo-700 transition-colors"
          >
            <PencilIcon class="h-5 w-5 text-white" />
          </button>
          <button
              @click="handleDeleteSession"
              class="p-2 rounded-full bg-red-600 hover:bg-red-700 transition-colors"
          >
            <TrashIcon class="h-5 w-5 text-white" />
          </button>
        </div>
      </div>

      <div v-if="isLoading" class="text-center py-12">
        <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-indigo-500 border-t-transparent"></div>
      </div>

      <div v-else-if="gameSession" class="space-y-6">
        <div class="admin-section bg-gradient-to-r from-indigo-600 to-purple-600 rounded-2xl p-6 opacity-0">
          <h1 class="text-3xl font-bold text-white mb-2">Admin View</h1>
          <p class="text-white/90 text-lg">{{ formatDate(gameSession.date) }}</p>
        </div>

        <!-- Teams Section -->
        <div class="admin-section bg-gray-800 rounded-xl p-6 opacity-0">
          <div class="flex items-center justify-between mb-4">
            <div class="flex items-center gap-3">
              <UserGroupIcon class="h-6 w-6 text-indigo-400" />
              <h2 class="text-xl font-bold text-white">Teams</h2>
            </div>
          </div>

          <div v-if="gameSession.teams && gameSession.teams.length > 0" class="space-y-3">
            <div
                v-for="team in gameSession.teams"
                :key="team.id"
                class="bg-gray-700 rounded-lg p-4 flex justify-between items-center group"
                :style="{ borderLeft: `4px solid ${team.color}` }"
            >
              <div>
                <span class="text-white font-medium">{{ team.name }}</span>
                <span class="text-gray-400 text-sm ml-3">{{ team.player_count }} players</span>
              </div>
              <button
                  @click="handleRemoveTeam(team.id)"
                  class="p-2 rounded-lg bg-red-600/0 group-hover:bg-red-600 transition-colors"
              >
                <TrashIcon class="h-5 w-5 text-red-400 group-hover:text-white" />
              </button>
            </div>
          </div>

          <div v-else class="text-gray-400 text-center py-4">
            No teams registered yet
          </div>
        </div>

        <!-- Playlists Section -->
        <div class="admin-section bg-gray-800 rounded-xl p-6 opacity-0">
          <div class="flex items-center justify-between mb-4">
            <div class="flex items-center gap-3">
              <MusicalNoteIcon class="h-6 w-6 text-indigo-400" />
              <h2 class="text-xl font-bold text-white">Playlists</h2>
            </div>
            <button
                @click="showPlaylistModal = true"
                class="p-2 rounded-lg bg-indigo-600 hover:bg-indigo-700 transition-colors"
            >
              <PlusIcon class="h-5 w-5 text-white" />
            </button>
          </div>

          <div v-if="gameSession.playlists && gameSession.playlists.length > 0" class="space-y-3">
            <div
                v-for="playlist in gameSession.playlists"
                :key="playlist.id"
                draggable="true"
                @dragstart="handleDragStart(playlist.id)"
                @drop.prevent="handleDrop(playlist.id)"
                @dragover.prevent
                class="bg-gray-700 rounded-lg p-4 flex items-center gap-4 group cursor-move hover:bg-gray-650"
            >
              <span class="text-gray-400 text-2xl">⋮⋮</span>
              <img
                  v-if="playlist.picture_url"
                  :src="playlist.picture_url"
                  :alt="playlist.name"
                  class="w-16 h-16 rounded-lg object-cover"
              />
              <span class="text-white font-medium flex-1">{{ playlist.name }}</span>
              <button
                  @click="handleRemovePlaylist(playlist.id)"
                  class="p-2 rounded-lg bg-red-600/0 group-hover:bg-red-600 transition-colors"
              >
                <TrashIcon class="h-5 w-5 text-red-400 group-hover:text-white" />
              </button>
            </div>
          </div>

          <div v-else class="text-gray-400 text-center py-4">
            No playlists added yet
          </div>
        </div>
      </div>
    </div>

    <!-- Add Playlist Modal -->
    <div
        v-if="showPlaylistModal"
        class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4"
        @click.self="showPlaylistModal = false"
    >
      <div class="bg-gray-800 rounded-2xl p-6 max-w-2xl w-full max-h-[80vh] overflow-y-auto">
        <h2 class="text-2xl font-bold text-white mb-4">Add Playlist</h2>

        <div class="space-y-2">
          <div
              v-for="playlist in availablePlaylists"
              :key="playlist.id"
              @click="handleAddPlaylist(playlist.id)"
              class="bg-gray-700 rounded-lg p-4 flex items-center gap-4 cursor-pointer hover:bg-gray-600 transition-colors"
          >
            <img
                v-if="playlist.picture_url"
                :src="playlist.picture_url"
                :alt="playlist.name"
                class="w-12 h-12 rounded-lg object-cover"
            />
            <span class="text-white">{{ playlist.name }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit Modal -->
    <div
        v-if="showEditModal"
        class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4"
        @click.self="showEditModal = false"
    >
      <div class="bg-gray-800 rounded-2xl p-6 max-w-md w-full">
        <h2 class="text-2xl font-bold text-white mb-4">Edit Game Session</h2>

        <div class="mb-4">
          <label class="block text-white font-medium mb-2">Scheduled Date & Time</label>
          <input
              v-model="editedDate"
              type="datetime-local"
              class="w-full px-4 py-3 rounded-lg bg-gray-700 text-white focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
        </div>

        <div class="flex gap-3">
          <button
              @click="showEditModal = false"
              class="flex-1 px-6 py-3 bg-gray-700 text-white rounded-lg hover:bg-gray-600 transition-colors"
          >
            Cancel
          </button>
          <button
              @click="handleUpdateSession"
              class="flex-1 px-6 py-3 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition-colors"
          >
            Save
          </button>
        </div>
      </div>
    </div>
  </div>
</template>