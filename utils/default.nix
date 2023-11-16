{ lib ? (import <nixpkgs> { }).lib }: rec {

  mergeFunc = f1: f2: inputAttrs:
    (f1 inputAttrs) // (f2 inputAttrs);

  homeRountin = unixname: { stateVersion, ... }: {
    home = {
      inherit stateVersion;
      username = unixname;
      homeDirectory = "/home/${unixname}";
    };
  };

  # same with `import ./home/${username}`
  # but append username ,homedir, version def
  importHomeDefault = username: (
    mergeFunc
      (import (../home + "/${username}"))
      (homeRountin username)
  );

  builtinDiff = a: b: builtins.filterAttrs (name: _attr: !builtins.hasAttr name b) a;

  seperateArgs = func: callParams: rec {
    defineParams = builtins.functionArgs func;
    explicitParam = builtins.intersectAttrs defineParams callParams;
    implicitParam = builtinDiff callParams defineParams;
  };

  mergeAttr = attrList:
    builtins.foldl' lib.recursiveUpdate { } attrList;

  mkBoolOption = { ... }@args:
    let
      inputs = {
        default = false;
        example = true;
        type = lib.types.bool;
      } // args;
    in
    lib.mkOption inputs;
}
