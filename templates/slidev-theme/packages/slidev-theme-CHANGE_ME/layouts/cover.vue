<script setup lang="ts">
import { handleBackground } from '@slidev/client/layoutHelper.ts'
import { computed } from 'vue'

const { background, author } = defineProps<{
  background?: string
  author?: string
}>()

const style = computed(() => handleBackground(background))
</script>

<template>
  <div class="slidev-layout cover" :style="style">
    <div class="cover-body">
      <slot />
      <p v-if="author" class="cover-author">{{ author }}</p>
    </div>
  </div>
</template>

<style scoped>
.cover-body {
  display: flex;
  flex-direction: column;
  justify-content: center;
  height: 100%;
}

.cover-author {
  color: var(--theme-muted);
  font-size: 0.9rem;
}
</style>
