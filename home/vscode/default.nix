{ pkgs, lib, config, ... }:
with lib;
let
  configDir = "Code";
  extensionDir = "vscode";

  userDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/${configDir}/User"
    else
      "${config.xdg.configHome}/${configDir}/User";
  configFilePath = "${userDir}/settings.json";
  keybindingsFilePath = "${userDir}/keybindings.json";
  snippetDir = "${userDir}/snippets";
  extensionPath = ".${extensionDir}/extensions";
in
{
  programs.vscode = {
    enable = lib.mkDefault true;
    extensions = with pkgs.vscode-extensions; [
      # vim key mode
      vscodevim.vim
      # color theme
      arcticicestudio.nord-visual-studio-code
      # icon theme
      pkief.material-icon-theme
      # git
      mhutchie.git-graph
      # nix reproduce
      mkhl.direnv
      # path auto complete
      christian-kohler.path-intellisense
      # remote ssh
      ms-vscode-remote.remote-ssh

      # cpp
      llvm-vs-code-extensions.vscode-clangd
      # nix
      bbenoist.nix
      jnoortheen.nix-ide
      # scala and chisel
      scalameta.metals
      scala-lang.scala
      # latex
      james-yu.latex-workshop
      # markdown
      yzhang.markdown-all-in-one
      # python
      ms-python.python
      ms-python.vscode-pylance
    ];
  };
  systemd.user.tmpfiles.rules = [
    "L ${configFilePath}/foo.json - - - - ${builtins.toString ./.}"
  ];
  home.file.${configFilePath}.source =  builtins.toPath ./settings.json;
  home.file.${keybindingsFilePath}.source = builtins.toPath ./keybindings.json;
}
