<script setup lang="ts">
const { label, color = 'gray' } = defineProps<{
  label: string
  color?: 'gray' | 'primary'
}>()
</script>

<template>
  <span class="demo-badge" :class="`is-${color}`">{{ label }}</span>
</template>

<style scoped>
.demo-badge {
  display: inline-block;
  padding: 0.1em 0.6em;
  border-radius: 999px;
  font-size: 0.8em;
  border: 1px solid currentColor;
}

.is-gray {
  color: var(--theme-muted, #666);
}

.is-primary {
  color: var(--theme-primary, #2b7de9);
}
</style>
