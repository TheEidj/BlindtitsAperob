<script setup lang="ts">
import { watch, nextTick } from 'vue'
import { animate } from 'animejs'

const props = defineProps<{
  title: string
  show: boolean
}>()

const emit = defineEmits<{
  (e:"close"): void
}>()

watch(() => props.show, async (isOpen) => {
  if (isOpen) {
    await nextTick()
    animate(
        '.modal-content',
        {
          opacity: [0, 1],
          scale: [0.9, 1],
          duration: 400,
          easing: 'ease-out-cubic'
        }
    )
  }
})
</script>

<template>
  <div
      v-if="show"
      class="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4"
      @click.self="emit('close')"
  >
    <div class="modal-content bg-gray-800 rounded-2xl p-6 max-w-md w-full max-h-[80vh] overflow-y-auto">
      <h2 class="text-2xl font-bold text-white mb-4">
        {{ title }}
      </h2>
      <div>
        <slot name="content"></slot>
      </div>
    </div>
  </div>
</template>
