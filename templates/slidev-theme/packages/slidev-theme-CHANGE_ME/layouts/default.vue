<script setup lang="ts">
import { handleBackground } from '@slidev/client/layoutHelper.ts'
import { computed } from 'vue'

const { background } = defineProps<{
  background?: string
}>()

const style = computed(() => handleBackground(background))
</script>

<template>
  <div class="slidev-layout default" :style="style">
    <slot />
  </div>
</template>
