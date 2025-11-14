
<script setup lang="ts" generic="T extends { id: number }">
import { ref, computed } from 'vue';
import BaseModal from '../atoms/BaseModal.vue';
import SearchInput from '../atoms/SearchInput.vue';

const props = defineProps<{
  show: boolean;
  title: string;
  items: T[];
  searchPlaceholder?: string;
  searchFields?: (keyof T)[];
  enableSearch?: boolean;
}>();

const emit = defineEmits<{
  (e: 'close'): void;
  (e: 'select', id: number): void;
}>();

const searchQuery = ref('');

const filteredItems = computed(() => {
  if (!props.enableSearch || !searchQuery.value) return props.items;

  const query = searchQuery.value.toLowerCase();

  return props.items.filter((item) => {
    // Si searchFields est spécifié, chercher uniquement dans ces champs
    if (props.searchFields && props.searchFields.length > 0) {
      return props.searchFields.some((field) => {
        const value = item[field];
        return value && String(value).toLowerCase().includes(query);
      });
    }

    // Sinon, chercher dans tous les champs de type string
    return Object.values(item).some((value) => {
      return typeof value === 'string' && (value as string).toLowerCase().includes(query);
    });
  });
});

const handleClose = () => {
  searchQuery.value = '';
  emit('close');
};

const handleSelect = (id: number) => {
  searchQuery.value = '';
  emit('select', id);
};
</script>

<template>
  <BaseModal :show="show" :title="title" @close="handleClose">
    <template #content>
      <SearchInput
          v-if="enableSearch"
          v-model="searchQuery"
          :placeholder="searchPlaceholder || 'Search...'"
      />

      <div class="space-y-2 max-h-96 overflow-y-auto">
        <div
            v-for="item in filteredItems"
            :key="item.id"
            @click="handleSelect(item.id)"
            class="bg-gray-700 rounded-lg p-4 cursor-pointer hover:bg-gray-600 transition-colors"
        >
          <slot name="item" :item="item" />
        </div>

        <div v-if="filteredItems.length === 0" class="text-center py-8 text-gray-400">
          <template v-if="searchQuery">
            No results found for "{{ searchQuery }}"
          </template>
          <template v-else>
            No items available
          </template>
        </div>
      </div>
    </template>
  </BaseModal>
</template>