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

## テンプレート一覧

| 名前 | 説明 | 中身 |
|---|---|---|
| `terraform` | Terraform devShell (最小構成) | `flake.nix`, `.envrc` |
| `slidev` | Slidev スライド (自作テーマの link 参照 + Cloudflare Workers デプロイ) | `flake.nix`, `.envrc`, `slides/` (package.json, slides.md 雛形, wrangler.jsonc), deploy CI, `.rumdl.toml` |
| `default` | `terraform` のエイリアス | 同上 |

`slidev` の初期化後の手順 (CHANGE_ME の置換、テーマの link 参照の前提、
デプロイ用 Secrets) は [templates/slidev/README.md](templates/slidev/README.md) を参照。

## ディレクトリ構成

```text
.
├── flake.nix                 # テンプレートの目次 (templates output を公開)
└── templates/
    └── terraform/
        ├── flake.nix         # 展開先にコピーされる本体 (terraform devShell)
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
