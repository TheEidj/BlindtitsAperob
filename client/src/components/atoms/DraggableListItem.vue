<script setup lang="ts">
import { ref } from 'vue';

defineProps<{
  id: number;
  draggable?: boolean;
}>();

const emit = defineEmits<{
  (e: 'dragStart', id: number): void;
  (e: 'drop', id: number): void;
  (e: 'dragEnter', id: number): void;
  (e: 'dragLeave', id: number): void;
}>();

const isDragging = ref(false);
const isDraggedOver = ref(false);

const handleDragStart = (e: DragEvent, id: number) => {
  if (!e.dataTransfer) return;
  e.dataTransfer.effectAllowed = 'move';
  e.dataTransfer.setData('text/html', e.currentTarget as any);
  isDragging.value = true;
  emit('dragStart', id);
};

const handleDragEnd = () => {
  isDragging.value = false;
};

const handleDragEnter = (id: number) => {
  isDraggedOver.value = true;
  emit('dragEnter', id);
};

const handleDragLeave = (id: number) => {
  isDraggedOver.value = false;
  emit('dragLeave', id);
};

const handleDrop = (id: number) => {
  isDraggedOver.value = false;
  emit('drop', id);
};
</script>

<template>
  <div
      :draggable="draggable"
      @dragstart="handleDragStart($event, id)"
      @dragend="handleDragEnd"
      @dragenter.prevent="handleDragEnter(id)"
      @dragleave="handleDragLeave(id)"
      @drop.prevent="handleDrop(id)"
      @dragover.prevent
      :class="[
      'bg-gray-700 rounded-lg p-4 flex items-center gap-4 group transition-all duration-200',
      draggable ? 'cursor-move' : '',
      isDragging ? 'opacity-50 scale-95' : '',
      isDraggedOver ? 'border-2 border-indigo-500 scale-105 bg-gray-650' : '',
      !isDragging && !isDraggedOver ? 'hover:bg-gray-650' : ''
    ]"
  >
    <span v-if="draggable" class="text-gray-400 text-2xl select-none">⋮⋮</span>

    <div class="flex-1">
      <slot name="content" />
    </div>

    <slot name="actions" />
  </div>
</template>