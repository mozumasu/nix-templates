# AGENTS.md — Slidev テーマ/アドオン開発の規範

このリポジトリは見た目の実装を引き受ける側。デッキ側の md に CSS を書かせない
ために、汎用的な見た目はここでレイアウト prop・コンポーネントとして提供する。

## テーマとアドオンの使い分け

- **テーマ** (`packages/slidev-theme-*`): 見た目全般。レイアウト・グローバル
  スタイル・デフォルト設定。1 デッキに 1 つしか当てられない
- **アドオン** (`packages/slidev-addon-*`): 独立機能 (コンポーネント等)。
  複数併用できる。機能のテーマ同梱は公式非推奨なのでこちらに置く
- デッキ側から同じ見た目のコピペ要望が 2 回来たら、prop かコンポーネントに
  昇格させてここで引き受ける

## スタイル実装

- グローバル CSS は**プレゼンター UI にも当たる**ため、必ず `.slidev-layout` で
  スコープする
- 色・寸法は `styles/tokens.css` の CSS 変数に集約し、レイアウト/コンポーネントは
  変数を参照する。`--slidev-theme-primary` は Slidev 組み込み UI
  (code-group のタブ下線等) が参照するので必ず定義しておく
- コードブロックの見た目は `--slidev-code-*` 変数の上書きで済ませ、
  `.slidev-code-*` の DOM 構造への直接スタイルは最小限にする
- ビルドは不要。`.vue` / `.ts` はソースのまま配布され、Slidev 側がコンパイルする

## レイアウトの作法

- `layouts/*.vue` はルート要素に `slidev-layout <レイアウト名>` クラスを付ける
- frontmatter の値は props で受ける。ただし `title` は Slidev の予約フィールドで
  props に届かないため `frontmatter` オブジェクト経由で取得する
- 背景は `handleBackground` (`@slidev/client/layoutHelper.ts`) で処理する

## example.md の作法

- headmatter と最初のスライドの frontmatter は**同じブロックにマージ**する
  (分けると空の 1 枚目が混入する)
- テーマの example.md: `theme: ./`、addon は**パッケージ名**で参照する
  (local path は pnpm workspace で components/ が解決されないことがある)
- アドオンの example.md: `theme: ../slidev-theme-<name>`、addon 自身は
  `./slidev-addon-<name>` と書く (`addons:` の相対パスは deck ディレクトリの
  1 つ上基準で解決されるため `./` だけでは壊れる)
- example.md は `.rumdl.toml` で formatter から除外している。
  ファイル先頭に `<!-- rumdl-disable -->` を置いてはいけない

## 型と検証

- `@slidev/client` は型なし配布のため `types/slidev-client.d.ts` で使う API だけ
  自前型付けしている。新しい API を使ったらそこに追記する
- 変更後は root で `pnpm lint` と `pnpm typecheck`、触ったパッケージで
  `pnpm build` を通してから完了報告する
- 見た目の確認は `pnpm screenshot` (PNG エクスポート) で行う。
  dev サーバーは `ghost run -- portless <name> pnpm dev`
