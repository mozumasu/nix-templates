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

        default = self.templates.terraform;
      };
    };
}
