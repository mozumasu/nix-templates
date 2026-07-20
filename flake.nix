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

        slidev = {
          path = ./templates/slidev;
          description = "Slidev deck with a local custom theme, pnpm devShell, and Cloudflare Workers deploy";
        };

        slidev-theme = {
          path = ./templates/slidev-theme;
          description = "Slidev theme + addon pnpm workspace monorepo with lint/typecheck and pnpm devShell";
        };

        default = self.templates.terraform;
      };
    };
}
