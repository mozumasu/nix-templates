// vue-tsc 用の型シム。

// Vite が実行時に定義する import.meta.env の最小型。vite は workspace の
// 直接依存ではなく vite/client の型を参照できないため自前で宣言する
interface ImportMeta {
  readonly env: {
    readonly DEV: boolean
    readonly PROD: boolean
    readonly BASE_URL: string
  }
}

// SVG は Vite が URL 文字列として解決する
declare module '*.svg' {
  const url: string
  export default url
}
