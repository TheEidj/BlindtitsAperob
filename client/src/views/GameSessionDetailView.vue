
<script setup lang="ts">
import { ref, onMounted, nextTick, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import type { Team } from '../types/team';
import GameSessionForm from '../components/organisms/GameSessionForm.vue';
import ManageableSection from '../components/organisms/ManageableSection.vue';
import SelectionModal from "../components/molecules/SelectionModal.vue";
import { formatDate } from '../utils/formatDate';
import LoadingSpinner from '../components/atoms/LoadingSpinner.vue';
import { useGameSessionManagement } from '../composables/useGameSessionManagement';
import {
  ArrowLeftIcon,
  UserGroupIcon,
  MusicalNoteIcon,
  SparklesIcon,
  TrashIcon,
  PencilIcon,
  CalendarIcon,
} from '@heroicons/vue/24/outline';
import { animate, stagger } from 'animejs';
import BaseModal from '../components/atoms/BaseModal.vue';
import TeamForm from '../components/organisms/TeamForm.vue';

const route = useRoute();
const router = useRouter();
const gameSessionId = Number(route.params.id);

const {
  gameSession,
  availablePlaylists,
  availableInterludes,
  isLoading,
  loadGameSession,
  handleRemoveTeam,
  handleAddPlaylist,
  handleRemovePlaylist,
  handleReorderPlaylists,
  handleAddInterlude,
  handleRemoveInterlude,
  handleReorderInterludes,
  handleDeleteSession,
} = useGameSessionManagement(gameSessionId);

const formattedDate = ref('');
const showTeamModal = ref(false);
const showEditModal = ref(false);
const showPlaylistModal = ref(false);
const showInterludeModal = ref(false);
const editingTeam = ref<Team | undefined>(undefined);

const statusColor = computed(() =>
    gameSession.value?.status === 'ongoing' ? 'bg-green-500' : 'bg-gray-500'
);

const load = async () => {
  await loadGameSession();
  if (gameSession.value) {
    formattedDate.value = formatDate(gameSession.value.date);
  }
  await nextTick();
  animate('.admin-section', {
    opacity: [0, 1],
    translateY: [20, 0],
    delay: stagger(100),
    duration: 600,
    easing: 'easeOutCubic',
  });
};

// Teams
const handleAddTeam = () => {
  editingTeam.value = undefined;
  showTeamModal.value = true;
};

const handleEditTeam = (teamId: number) => {
  const team = gameSession.value?.teams?.find((t) => t.id === teamId);
  if (team) {
    editingTeam.value = team;
    showTeamModal.value = true;
  }
};

const handleTeamFormDone = () => {
  showTeamModal.value = false;
  editingTeam.value = undefined;
  load();
};

// Playlists
const handleAddPlaylistAndClose = async (playlistId: number) => {
  const success = await handleAddPlaylist(playlistId);
  if (success) showPlaylistModal.value = false;
};

// Interludes
const handleAddInterludeAndClose = async (interludeId: number) => {
  const success = await handleAddInterlude(interludeId);
  if (success) showInterludeModal.value = false;
};

// Session
const handleDeleteSessionAndRedirect = async () => {
  const success = await handleDeleteSession();
  if (success) await router.push('/game-sessions');
};


// TODO: Find a way to track back where the user came from
const goBack = () => router.push('/game-sessions');

onMounted(load);
</script>

<template>
  <div class="flex items-center justify-between mb-6">
    <button
        @click="goBack"
        class="p-2 rounded-full bg-gray-800 hover:bg-gray-700 transition-colors"
    >
      <ArrowLeftIcon class="h-6 w-6 text-white" />
    </button>
  </div>

  <LoadingSpinner v-if="isLoading" />

  <div v-else-if="gameSession" class="space-y-6">
    <!-- Header -->
    <div class="admin-section bg-gradient-to-r from-indigo-600 to-purple-600 rounded-2xl p-6 opacity-0">
      <div class="flex justify-between items-center">
        <div>
          <div class="flex items-center gap-4">
            <h1 class="text-3xl font-bold text-white">#{{ gameSession.number }}</h1>
            <span
                :class="statusColor"
                class="px-3 py-1 rounded-full text-xs font-bold text-white pointer-events-none"
            >
                  {{ gameSession.status }}
                </span>
          </div>
          <div class="flex justify-between items-center">
            <div
                v-if="gameSession.date"
                class="flex items-center gap-2 pointer-events-none text-white/90 text-lg"
            >
              <CalendarIcon class="h-5 w-5 text-indigo-400" />
              <span class="text-white font-medium">{{ formattedDate }}</span>
            </div>
          </div>
        </div>
        <div class="flex flex-col gap-2">
          <button
              @click="showEditModal = true"
              class="p-2 rounded-full bg-indigo-600 hover:bg-indigo-700 transition-colors"
          >
            <PencilIcon class="h-5 w-5 text-white" />
          </button>
          <button
              @click="handleDeleteSessionAndRedirect"
              class="p-2 rounded-full bg-red-600 hover:bg-red-700 transition-colors"
          >
            <TrashIcon class="h-5 w-5 text-white" />
          </button>
        </div>
      </div>
    </div>

    <!-- Playlists Section (remove only) -->
    <ManageableSection
        title="Playlists"
        :icon="MusicalNoteIcon"
        :items="gameSession.playlists || []"
        :draggable="true"
        :can-edit="false"
        :can-remove="true"
        empty-message="No playlists added yet"
        @add="showPlaylistModal = true"
        @remove="handleRemovePlaylist"
        @reorder="handleReorderPlaylists"
    >
      <template #item="{ item }">
        <span class="text-white font-medium">{{ item.name }}</span>
      </template>

      <template #modal>
        <SelectionModal
            title="Add Playlist"
            :show="showPlaylistModal"
            :items="availablePlaylists"
            :enable-search="true"
            :search-fields="['name']"
            search-placeholder="Search playlists..."
            @close="showPlaylistModal = false"
            @select="handleAddPlaylistAndClose"
        >
          <template #item="{ item }">
            <span class="text-white">{{ item.name }}</span>
          </template>
        </SelectionModal>
      </template>
    </ManageableSection>

    <!-- Interludes Section -->
    <ManageableSection
        title="Interludes"
        :icon="SparklesIcon"
        :items="gameSession.interludes || []"
        :draggable="true"
        :can-edit="false"
        :can-remove="true"
        empty-message="No interludes added yet"
        @add="showInterludeModal = true"
        @remove="handleRemoveInterlude"
        @reorder="handleReorderInterludes"
    >
      <template #item="{ item }">
        <div>
          <span class="text-white font-medium">{{ item.title }}</span>
          <p class="text-gray-400 text-sm mt-1 line-clamp-1">{{ item.lyrics }}</p>
        </div>
      </template>

      <template #modal>
        <SelectionModal
            title="Add Interlude"
            :show="showInterludeModal"
            :items="availableInterludes"
            :enable-search="true"
            :search-fields="['title', 'lyrics']"
            search-placeholder="Search interludes..."
            @close="showInterludeModal = false"
            @select="handleAddInterludeAndClose"
        >
          <template #item="{ item }">
            <div>
              <span class="text-white font-medium">{{ item.title }}</span>
              <p class="text-gray-400 text-sm mt-1 line-clamp-2">{{ item.lyrics }}</p>
            </div>
          </template>
        </SelectionModal>
      </template>
    </ManageableSection>

    <!-- Teams Section (with edit & remove) -->
    <ManageableSection
        title="Teams"
        :icon="UserGroupIcon"
        :items="gameSession.teams || []"
        :draggable="false"
        :can-edit="true"
        :can-remove="true"
        empty-message="No teams registered yet"
        @add="handleAddTeam"
        @edit="handleEditTeam"
        @remove="handleRemoveTeam"
    >
      <template #item="{ item }">
        <div :style="{ borderLeft: `4px solid blue` }" class="pl-3">
          <span class="text-white font-medium">{{ item.name }}</span>
          <span class="text-gray-400 text-sm ml-3">{{ item.player_count }} players</span>
        </div>
      </template>

      <template #modal>
        <BaseModal
            :title="editingTeam ? 'Edit Team' : 'Register Team'"
            :show="showTeamModal"
            @close="showTeamModal = false"
        >
          <template #content>
            <TeamForm
                :mode="editingTeam ? 'edit' : 'register'"
                :session="gameSession"
                :team="editingTeam"
                @done="handleTeamFormDone"
            />
          </template>
        </BaseModal>
      </template>
    </ManageableSection>
  </div>

  <BaseModal title="Edit Game Session" :show="showEditModal" @close="showEditModal = false">
    <template #content>
      <GameSessionForm
          mode="edit"
          :session="gameSession"
          @done="
            () => {
              showEditModal = false;
              load();
            }
          "
      />
    </template>
  </BaseModal>
</template>