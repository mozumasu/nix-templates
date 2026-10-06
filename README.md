# nix-templates

`nix flake init --template` で使える個人用テンプレート集。

## 使い方

```sh
# 明示指定
nix flake init --template github:mozumasu/nix-templates#terraform

# default テンプレート (= terraform)
nix flake init --template github:mozumasu/nix-templates
```

展開後:

```sh
direnv allow      # or `nix develop`
```

### flake を 1 箇所に置いて複数プロジェクトから参照する

プロジェクトごとに `flake.nix` をコピーせず、展開済みの flake を 1 箇所
(例: `~/dotfiles/flakes/terragrunt`) に置き、各プロジェクトには `.envrc` だけを置く使い方もできる:

```sh
# 共有置き場に一度だけ展開
mkdir -p ~/dotfiles/flakes/terragrunt && cd ~/dotfiles/flakes/terragrunt
nix flake init --template github:mozumasu/nix-templates#terragrunt

# 各プロジェクト側は .envrc のみ
echo 'use flake ~/dotfiles/flakes/terragrunt' > .envrc
direnv allow
```

ツールのバージョン更新は共有側の `nix flake update` 一発で全プロジェクトに反映される。

## テンプレート一覧

| 名前 | 説明 | 中身 |
|---|---|---|
| `terraform` | Terraform devShell (最小構成) | `flake.nix`, `flake.lock`, `.envrc` |
| `terragrunt` | Terraform + Terragrunt devShell | `flake.nix`, `flake.lock`, `.envrc` |
| `mise` | mise 本体だけの devShell。ツールのバージョンはプロジェクトの `mise.toml` に従う | `flake.nix`, `flake.lock`, `.envrc` |
| `slidev` | Slidev スライド (自作テーマの link 参照 + Cloudflare Workers デプロイ) | `flake.nix`, `.envrc`, `slides/` (package.json, slides.md 雛形, wrangler.jsonc), deploy CI, `.rumdl.toml`, `AGENTS.md`, `.claude/settings.json` |
| `slidev-theme` | Slidev テーマ + アドオンの pnpm workspace モノレポ | `flake.nix`, `.envrc`, `packages/slidev-theme-*` (layouts, styles), `packages/slidev-addon-*` (components), eslint + vue-tsc, lint/typecheck/build CI, `.rumdl.toml`, `AGENTS.md`, `.claude/settings.json` |
| `default` | `terraform` のエイリアス | 同上 |

`slidev` の初期化後の手順 (CHANGE_ME の置換、テーマの link 参照の前提、
デプロイ用 Secrets) は [templates/slidev/README.md](templates/slidev/README.md) を参照。
`slidev-theme` の初期化後の手順は
[templates/slidev-theme/README.md](templates/slidev-theme/README.md) を参照。
2 つはペアで使う想定: `slidev-theme` で作ったテーマリポジトリを、
`slidev` で作ったデッキが隣のディレクトリから `link:` 参照する。

## ディレクトリ構成

```text
.
├── flake.nix                 # テンプレートの目次 (templates output を公開)
└── templates/
    └── terraform/            # terragrunt なども同じ構成
        ├── flake.nix         # 展開先にコピーされる本体 (terraform devShell)
        ├── flake.lock        # 展開先にコピーされるバージョン固定
        └── .envrc            # 展開先にコピーされる本体 (use flake)
```

- ルート `flake.nix` は「どのサブディレクトリをどの名前で公開するか」の目次。消すとテンプレートとして機能しない。
- `templates/<name>/` 配下のファイル一式がユーザーのプロジェクトに丸ごとコピーされる。

## 新しいテンプレートを追加する

1. `templates/<name>/` にファイル一式を置く (最低 `flake.nix`)
2. ルートの `flake.nix` の `templates` に1エントリ追加

   ```nix
   <name> = {
     path = ./templates/<name>;
     description = "...";
   };
   ```

3. `git add` してから `nix flake show` で `templates.<name>` が出れば OK

> Nix は git-tracked なファイルしか flake の入力として認識しない。追加した `.envrc` などが `nix flake init` の展開結果に含まれないときは、テンプレート側のディレクトリで `git add` 済みか確認する。
