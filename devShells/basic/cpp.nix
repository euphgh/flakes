{ mkShell
, stdenv
, clang
, clang-tools
, bear
, gnumake
, ccache
, lldb
}:
mkShell {
  packages = [
    stdenv.cc
    clang
    clang-tools
    bear
    ccache
    gnumake
    lldb
  ];
  shellHook = ''
  ccache --set-config=sloppiness=locale,time_macros
  export PATH="${clang-tools}/bin:$PATH"'';
}
