# nix-shell -p home-manager
# nix profile upgrade timon-nix
# flake.nix skeleton:

{
  description = "MacOS backend dev system";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

#  outputs = { self, nixpkgs }: {
#    imports = [
#	./programs/aerospace
#    ];
  outputs = { self, nixpkgs, nix-darwin, flake-utils,determinate,}@inputs: {
    packages."aarch64-darwin".default = let
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config = {
            allowUnfree = true;
            allowUnfreePredicate = _: true;
        };
      };
    in pkgs.buildEnv {
      name = "home-packages";
      paths = with pkgs; [
        # general tools
        pipx
        git
        # CLI tools for conventional commits and semver
        cocogitto # cog
        gnupg
        curl
        wget
        jq
        cmake
        gcc
        gnumake
        # telescope.nvim
        ripgrep
        fd
        # devshell
        devenv
        direnv
        starship
        oh-my-zsh
        # ... add your tools here
        # vim
        neovim
        fzf
        nodejs_24
        # Not really sure if the nvim plugin works actually
        vimPlugins.telescope-fzf-native-nvim
        # These are better to be installed with brew until this is merged: https://github.com/NixOS/nix/issues/7055
        # MacOS wm
        # aerospace
        # terminal emulator
        # wezterm 
        # GUI apps
        # ---
        # Shell/code summary utility
        tokei
        fastfetchMinimal
        tree
        eza
        # --- obsidian ---
        obsidian
        # --- tailscale ---
        tailscale
        discord
      ];
    };
  };

}
