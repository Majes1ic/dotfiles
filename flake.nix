{
  description = "Tom's NixOS Flake";

  inputs = {
    # NOTE: Use the `nix flake metadata <flake_url>` command to check if a
    # flake needs nixpkgs.follows defined
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-colors.url = "github:misterio77/nix-colors";
    impermanence.url = "github:nix-community/impermanence";

    # nix-resources = {
    #   url = "git+ssh://git@github.com/JManch/nix-resources";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    spicetify-nix = {
      url = "github:JManch/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , ...
    } @ inputs:
    let
      inherit (self) outputs;
      systems = [ "x86_64-linux" ];
      username = "tom";

      mkLib = nixpkgs:
        nixpkgs.lib.extend
          (final: prev: (import ./lib final) // home-manager.lib);

      lib = mkLib nixpkgs;

      forEachSystem = f:
        nixpkgs.lib.genAttrs systems (system:
          f (nixpkgs.legacyPackages.${system}));
    in
    {
      formatter = forEachSystem (pkgs: pkgs.nixpkgs-fmt);

      nixosConfigurations = {
        maximum = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            hostname = "maximum";
            inherit inputs outputs username lib;
          };
          modules = [
            ./modules/nixos
            ./hosts/maximum
          ];
        };

        virtual = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            hostname = "virtual";
            inherit inputs outputs username lib;
          };
          modules = [
            ./modules/nixos
            ./hosts/virtual
          ];
        };
      };
    };
}
