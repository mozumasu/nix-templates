import antfu from '@antfu/eslint-config'

export default antfu({
  // rumdl (markdown formatter) が生成するキャッシュ JSON は lint 対象外
  ignores: ['**/.rumdl_cache/**'],
  // フォーマットは行わず、コード品質のチェックのみに使う
  formatters: false,
  // スライド本文 (example.md) 内のコードブロックは表示用の断片のため対象外
  markdown: false,
  rules: {
    // 短い要素は 1 行で書く流儀のため強制しない
    'vue/singleline-html-element-content-newline': 'off',
    // pnpm-workspace.yaml への設定追加 (shellEmulator 等) は挙動を変えるため lint では強制しない
    'pnpm/yaml-enforce-settings': 'off',
  },
})
