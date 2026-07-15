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

        default = self.templates.terraform;
      };
    };
}
