{ mkShell
, python3
, black
, pyPkgs ? (ps: with ps; [ ])
}:
mkShell {
  packages = [
    python3
    black
    (python3.withPackages pyPkgs)
  ];
}
