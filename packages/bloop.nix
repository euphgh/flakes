{ bloop, fetchurl, stdenv, version ? "1.5.15", ... }:
let
  hashMap = {
    "1.5.15" = {
      linux = "sha256-bC43GBIGxelSx++I1ElPd8twrr5nDaZHC2G0OCsx5xQ=";
      darwin = "sha256-lgWXdhDjE8lIzbUkWFJV3k+muUZaSpsc9n6PuuXv1hc=";
    };
    "1.5.13" = {
      linux = "sha256-OgOkkQ2uv1/mutlajfnbKe9YUtWCilaiWef6fZ7m0Qk=";
      darwin = "sha256-Xp0FF8/5NQG14OhZgQ7PZTyDC5hNG9q5Qq5q3JlQxA0=";
    };
    bash = "sha256-2mt+zUEJvQ/5ixxFLZ3Z0m7uDSj/YE9sg/uNMjamvdE=";
    fish = "sha256-eFESR6iPHRDViGv+Fk3sCvPgVAhk2L1gCG4LnfXO/v4=";
    zsh = "sha256-WNMsPwBfd5EjeRbRtc06lCEVI2FVoLfrqL82OR0G7/c=";
  };
in

bloop.overrideAttrs rec {
  inherit version;

  platform =
    if stdenv.isLinux && stdenv.isx86_64 then "x86_64-pc-linux"
    else if stdenv.isDarwin && stdenv.isx86_64 then "x86_64-apple-darwin"
    else throw "unsupported platform";

  bloop-bash = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bash-completions";
    sha256 = hashMap.bash;
  };

  bloop-fish = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/fish-completions";
    sha256 = hashMap.fish;
  };

  bloop-zsh = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/zsh-completions";
    sha256 = hashMap.zsh;
  };

  bloop-binary = fetchurl {
    url = "https://github.com/scalacenter/bloop/releases/download/v${version}/bloop-${platform}";
    sha256 =
      if stdenv.isLinux && stdenv.isx86_64 then hashMap.${version}.linux
      else if stdenv.isDarwin && stdenv.isx86_64 then hashMap.${version}.darwin
      else throw "unsupported platform";
  };
}
