{
  description = "mozumasu's Nix flake templates";

  outputs =
    { self }:
    {
      templates = {
        terraform = {
          path = ./templates/terraform;
          description = "Minimal Terraform devShell";
        };

        terragrunt = {
          path = ./templates/terragrunt;
          description = "Terraform + Terragrunt devShell";
        };

        slidev = {
          path = ./templates/slidev;
          description = "Slidev deck with a local custom theme, pnpm devShell, and Cloudflare Workers deploy";
        };

        slidev-theme = {
          path = ./templates/slidev-theme;
          description = "Slidev theme + addon pnpm workspace monorepo with lint/typecheck and pnpm devShell";
        };

        default = {
          path = ./templates/default;
          description = "Minimal devShell starter";
        };
      };
    };
}
