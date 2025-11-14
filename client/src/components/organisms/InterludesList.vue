<script setup lang="ts">
import { computed } from 'vue';
import type { Interlude } from '../../types/interlude';
import InterludeCard from '../molecules/InterludeCard.vue';
import CollapsibleSection from '../molecules/CollapsibleSection.vue';

const props = defineProps<{
  interludes: Interlude[];
}>();

const notDoneInterludes = computed(() =>
    props.interludes.filter((i) => !i.done)
);

const doneInterludes = computed(() =>
    props.interludes.filter((i) => i.done)
);
</script>

<template>
  <div class="space-y-6">
    <CollapsibleSection
        title="Not Done"
        :count="notDoneInterludes.length"
        :defaultOpen="true"
    >
      <InterludeCard
          v-for="interlude in notDoneInterludes"
          :key="interlude.id"
          :interlude="interlude"
      />

      <div v-if="notDoneInterludes.length === 0" class="text-center py-8 text-gray-500">
        No interludes to play
      </div>
    </CollapsibleSection>

    <CollapsibleSection
        title="Done"
        :count="doneInterludes.length"
        :defaultOpen="false"
    >
      <InterludeCard
          v-for="interlude in doneInterludes"
          :key="interlude.id"
          :interlude="interlude"
      />

      <div v-if="doneInterludes.length === 0" class="text-center py-8 text-gray-500">
        No interludes completed yet
      </div>
    </CollapsibleSection>
  </div>
</template>