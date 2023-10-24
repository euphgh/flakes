{ mkShell
, stdenv
, clang
, clang-tools
, bear
, gnumake
, ccache
}:
mkShell {
  packages = [
    stdenv.cc
    clang
    clang-tools
    bear
    ccache
    gnumake
  ];
  shellHook = ''
  ccache --set-config=sloppiness=locale,time_macros
  export PATH="${clang-tools}/bin:$PATH"'';
}
