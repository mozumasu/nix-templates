# Slidev deck

Slidev + 自作テーマ (link 参照) のスライドプロジェクト。
テーマ参照などは役割別のプレースホルダーになっているので、
**一括置換してから** `pnpm install` する。

## 初期化

```sh
nix flake init -t github:mozumasu/nix-templates#slidev
direnv allow
# 下記のプレースホルダー置換をしてから:
cd slides && pnpm install
```

## プレースホルダーの置換

役割別に分かれているので、種類ごとに一括置換できる
(必須。置換するまで `pnpm install` は失敗する):

```sh
# 1. テーマのリポジトリ名 (例: findy-slidev)
git grep -l THEME_REPO_CHANGE_ME | xargs perl -pi -e 's/THEME_REPO_CHANGE_ME/findy-slidev/g'
# 2. テーマ短縮名 = slidev-theme-<name> の <name> (例: findy)
git grep -l THEME_CHANGE_ME | xargs perl -pi -e 's/THEME_CHANGE_ME/findy/g'
# 3. プロジェクト名 = リポジトリ名推奨 (例: my-talk)
git grep -l PROJECT_CHANGE_ME | xargs perl -pi -e 's/PROJECT_CHANGE_ME/my-talk/g'
```

置換後に `git grep CHANGE_ME` で残りを確認する。残る `CHANGE_ME` は
`slides/slides.md` の本文 (タイトル・イベント名・所属) だけで、
これはスライドを書きながら手で埋める。

### 各プレースホルダーの補足

1. **THEME_REPO_CHANGE_ME** (テーマのリポジトリ名)
   - `slides/package.json` の `link:../../<repo>/...`: 隣にチェックアウトした
     テーマリポジトリを参照する前提 (ghq の標準配置)。
     npm 公開テーマを使うならバージョン指定に書き換える
   - デッキとテーマが**別オーナー配下**にある場合 (例: デッキが `github.com/<org>/`、
     テーマが `github.com/<user>/`) は `link:../../../<owner>/<theme-repo>/packages/...` と
     1 階層深くする。デッキを `slides/<slug>/` に掘るモノレポ構成にした場合も同様に
     1 階層深くする。macOS はパスの大文字小文字を区別しないため、
     誤ったパスでもディレクトリ自体には解決されてしまい気づきにくい
   - `.github/workflows/deploy-slides.yml` の checkout 先。`ref` は固定したい
     コミット SHA にする
2. **THEME_CHANGE_ME** (テーマ短縮名)
   - `slides/package.json` の依存キー `slidev-theme-<name>` / `slidev-addon-<name>` と
     `slides/slides.md` headmatter の `theme:` / `addons:` が対応している。
     **キー側の置換を忘れると Slidev がテーマを解決できない**
   - `slides/slides.md` のレイアウト名 (`talk-cover` / `profile` / `toc`) は
     テーマ側に存在する必要がある。無いテーマでは `cover` / `default` 等へ変更する
3. **PROJECT_CHANGE_ME** (プロジェクト名)
   - `slides/package.json` の `name`: `<リポジトリ名>-slides` になる。
     portless の worktree URL (`https://<worktree>.<name>.localhost`) に使われる
   - `slides/wrangler.jsonc` の `name`: Workers のサブドメインになる

## デプロイ用 Secrets

- `CLOUDFLARE_API_TOKEN` / `CLOUDFLARE_ACCOUNT_ID`
- `THEME_REPO_READ_TOKEN` (テーマリポジトリが private の場合の contents:read fine-grained PAT)

## 開発

```sh
cd slides
pnpm dev      # dev サーバー (--port ${PORT:-3030} 対応済みなので portless でも動く)
pnpm build    # dist/ に SPA ビルド
pnpm export   # PDF/PNG エクスポート (playwright-chromium は devDependencies に同梱)
```

Claude Code から起動する場合は `ghost run -- portless <name> pnpm dev`。

## 注意

- スライドの md は `.rumdl.toml` で formatter から除外している
  (rumdl がスライド区切りの `---` を壊すため)。新しいページを
  `slides/pages/` 以外に置くなら exclude に追加する
- スライド内の画像は `slides/public/` に置き、静的 `src="/..."` ではなく
  `:src="'/...'"` のバインディング形式で参照する (slide-import-guard 対策)
