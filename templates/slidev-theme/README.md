# Slidev theme + addon monorepo

自作 Slidev テーマとアドオンを 1 リポジトリで開発する pnpm workspace モノレポ。
公式 slidevjs/themes と同じ方式で、`slidev` テンプレート (デッキ側) から
`link:` 参照される前提の構成。**public リポジトリでの運用を前提**にしており、
デッキ側 CI からの checkout にトークンは不要。

## 初期化

```sh
nix flake init -t github:mozumasu/nix-templates#slidev-theme
direnv allow
# CHANGE_ME を置換してから:
pnpm install
```

生成された `pnpm-lock.yaml` はコミットする
(CI が `pnpm install --frozen-lockfile` で参照するため、無いと CI が落ちる)。

## CHANGE_ME の置換箇所

`CHANGE_ME` をテーマ名に一括置換し、ディレクトリ名も合わせる:

```sh
NAME=myname
perl -pi -e "s/CHANGE_ME/$NAME/g" $(git grep -l CHANGE_ME)
mv packages/slidev-theme-CHANGE_ME "packages/slidev-theme-$NAME"
mv packages/slidev-addon-CHANGE_ME "packages/slidev-addon-$NAME"
```

- `package.json` (root) の `name`: リポジトリ名推奨。
  portless の URL (`https://<worktree>.<name>.localhost`) に使われる
- `packages/slidev-theme-CHANGE_ME/`: パッケージ名・example.md・説明文
- `packages/slidev-addon-CHANGE_ME/`: 同上

## 開発

```sh
cd packages/slidev-theme-<name>
pnpm dev          # example.md をライブプレビュー (--port ${PORT:-3030} 対応済み)
pnpm screenshot   # PNG エクスポート (playwright-chromium 同梱)

pnpm lint         # root で: eslint (@antfu/eslint-config)
pnpm typecheck    # root で: vue-tsc
```

Claude Code から起動する場合は `ghost run -- portless <name> pnpm dev`。

## 構成のポイント

- **テーマ**: 見た目全般 (レイアウト・グローバルスタイル・デフォルト設定)。
  `layouts/*.vue` を足すとレイアウトが増え、`styles/tokens.css` の CSS 変数で
  ブランドカラーを差し替える。ビルド不要 (`.vue`/`.ts` はソースのまま配布)
- **アドオン**: 独立機能 (コンポーネント等)。`components/*.vue` を置くだけで
  デッキから使える。テーマへの機能同梱は公式非推奨のためアドオンに分離している
- テーマ → アドオンは `workspace:*` で依存し、example.md の `addons:` は
  **パッケージ名**で参照する (local path は workspace で解決されないことがある)
- アドオン自身の example.md では addon を `./slidev-addon-<name>` と書く
  (`addons:` の相対パスは deck ディレクトリの 1 つ上基準で解決されるため)
- `types/slidev-client.d.ts`: `@slidev/client` は型なし配布のため、使う API だけ
  自前で型付けして vue-tsc を通している。新しい API を使うときはここに追記する

## デッキ側からの参照

デッキは `slidev` テンプレートで別リポジトリに作り、ghq の標準配置で
隣にチェックアウトしたこのリポジトリを `link:` 参照する:

```jsonc
// デッキ側 slides/package.json
"slidev-theme-<name>": "link:../../<this-repo>/packages/slidev-theme-<name>"
```

public リポジトリなので `link:` 以外の参照も選べる:

- **Git 依存** (デッキ CI で隣に checkout しなくてよい):
  `"slidev-theme-<name>": "github:<user>/<this-repo>#path:packages/slidev-theme-<name>"`
  (モノレポのサブディレクトリ参照は pnpm のみ対応)
- **npm 公開**: 命名規約 (`slidev-theme-*` / `slidev-addon-*`) と keywords を
  満たしたまま `pnpm publish` (ビルド不要)。`slidev-theme` keyword 付きで公開すると
  テーマギャラリー <https://sli.dev/resources/theme-gallery> に載る

デッキ側テンプレートの README にある `THEME_REPO_READ_TOKEN` (private テーマ用の
fine-grained PAT) はこのリポジトリが public なら不要。

## 注意

- example.md は `.rumdl.toml` で formatter から除外している
  (rumdl がスライド区切りの `---` を壊すため)
- headmatter と最初のスライドの frontmatter は同じブロックにマージする
  (分けると空の 1 枚目が混入する)
