
<script setup lang="ts" generic="T extends { id: number }">
import { ref } from 'vue';
import SectionHeader from '../molecules/SectionHeader.vue';
import DraggableListItem from '../atoms/DraggableListItem.vue';
import { TrashIcon, PencilIcon } from '@heroicons/vue/24/outline';

defineProps<{
  title: string;
  icon: any;
  items: T[];
  draggable?: boolean;
  emptyMessage?: string;
  canEdit?: boolean;
  canRemove?: boolean;
}>();

const emit = defineEmits<{
  (e: 'add'): void;
  (e: 'edit', id: number): void;
  (e: 'remove', id: number): void;
  (e: 'reorder', fromId: number, toId: number): void;
}>();

const draggedId = ref<number | null>(null);
const dragOverId = ref<number | null>(null);

const handleDragStart = (id: number) => {
  draggedId.value = id;
};

const handleDragEnter = (id: number) => {
  dragOverId.value = id;
};

const handleDragLeave = () => {
  dragOverId.value = null;
};

const handleDrop = (targetId: number) => {
  if (draggedId.value && draggedId.value !== targetId) {
    emit('reorder', draggedId.value, targetId);
  }
  draggedId.value = null;
  dragOverId.value = null;
};
</script>

<template>
  <div class="admin-section bg-gray-800 rounded-xl p-6 opacity-0">
    <SectionHeader :title="title" :icon="icon" @add="emit('add')" />

    <div v-if="items.length > 0" class="space-y-3">
      <DraggableListItem
          v-for="item in items"
          :key="item.id"
          :id="item.id"
          :draggable="draggable"
          @drag-start="handleDragStart"
          @drag-enter="handleDragEnter"
          @drag-leave="handleDragLeave"
          @drop="handleDrop"
      >
        <template #content>
          <slot name="item" :item="item" />
        </template>

        <template #actions>
          <div class="flex gap-2">
            <!-- Edit button -->
            <slot name="edit-action" :item="item">
              <button
                  v-if="canEdit"
                  @click="emit('edit', item.id)"
                  class="p-2 rounded-lg bg-blue-600/0 group-hover:bg-blue-600 transition-colors"
              >
                <PencilIcon class="h-5 w-5 text-blue-400 group-hover:text-white" />
              </button>
            </slot>

            <!-- Remove button -->
            <slot name="remove-action" :item="item">
              <button
                  v-if="canRemove"
                  @click="emit('remove', item.id)"
                  class="p-2 rounded-lg bg-red-600/0 group-hover:bg-red-600 transition-colors"
              >
                <TrashIcon class="h-5 w-5 text-red-400 group-hover:text-white" />
              </button>
            </slot>
          </div>
        </template>
      </DraggableListItem>
    </div>

    <div v-else class="text-gray-400 text-center py-4">
      {{ emptyMessage || 'No items yet' }}
    </div>
  </div>
  <slot name="modal" />
</template>