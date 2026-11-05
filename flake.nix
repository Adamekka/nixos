{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/master";

    # chaotic = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:lonerOrz/nyx-loner/main";
    # };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      # chaotic,
      nix-cachyos-kernel,
      nur,
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix

          # MARK: Modules

          # chaotic.nixosModules.default
          nur.modules.nixos.default

          # MARK: Overlays

          {
            nixpkgs.overlays = [
              nix-cachyos-kernel.overlays.pinned
              (_: prev: {
                nur = import nur {
                  nurpkgs = prev;
                  pkgs = prev;
                  repoOverrides.forkprince =
                    let
                      revision = (builtins.fromJSON (builtins.readFile "${nur}/repos.json.lock")).repos.forkprince;
                    in
                    # Avoid Nix's Unicode filename failure when unpacking ZIP.
                    import (builtins.fetchTarball {
                      inherit (revision) sha256;
                      url = "${revision.url}/archive/${revision.rev}.tar.gz";
                    }) { pkgs = prev; };
                };
              })
            ];
          }
        ];
      };
    };
}
