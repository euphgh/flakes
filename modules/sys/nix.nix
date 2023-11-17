{ pkgs, lib, ... }@inputs:
{
  nixpkgs.config = {
    allowUnfree = true;
  };
  nix = {
    settings = {
      substituters = [
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-users = [ "root" "@wheel" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      max-jobs = lib.mkDefault 8;
    };
    package = pkgs.nixUnstable;
    gc = {
      automatic = true;
      dates = "weekly";
    };
    registry = {
      sys = lib.mkDefault {
        from = { type = "indirect"; id = "sys"; };
        flake = inputs.nixpkgs;
      };
      euphgh = lib.mkDefault {
        flake = inputs.nixpkgs;
        from = { type = "indirect"; id = "euphgh"; };
        to = {
          owner = "euphgh";
          repo = "flakes";
          type = "github";
        };
      };
    };
  };
}
