// vue-tsc 用の「@slidev/client」最小型定義。
// 「@slidev/client」は型定義なしの .ts ソースを配布しており、Slidev のビルド時
// define (__DEV__ 等) や仮想モジュール (#slidev/*) 前提のため単体では型検査
// できない。tsconfig の paths で本物の解決を遮り、このリポジトリで使う API
// だけをここで型付けする。新しい API を使うときはここに追記すること。
declare module '@slidev/client' {
  import type { ComputedRef } from 'vue'

  export interface SlideRouteLite {
    no: number
    meta: Record<string, unknown>
  }

  export function useNav(): {
    slides: ComputedRef<SlideRouteLite[]>
    currentPage: ComputedRef<number>
    total: ComputedRef<number>
    isPrintMode: ComputedRef<boolean>
    go: (page: number | string, clicks?: number) => Promise<void>
  }
}

declare module '@slidev/client/layoutHelper.ts' {
  import type { CSSProperties } from 'vue'

  export function handleBackground(background?: string, dim?: boolean): CSSProperties
}

declare module '@slidev/client/styles/layouts-base.css' {}
