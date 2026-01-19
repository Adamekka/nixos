{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    chaotic = {
      url = "github:lonerOrz/nyx-loner/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };
  };

  outputs = { self, nixpkgs, chaotic, nur }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix

        chaotic.nixosModules.default
        nur.modules.nixos.default
      ];
    };
  };
}
