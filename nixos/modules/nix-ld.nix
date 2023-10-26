{ pkgs, ... }: {
  # Enable nix ld
  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    glib
    openssl
    gtk3
    libGL
  ];
}
