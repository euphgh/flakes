{ pkgs, lib, config, ... }:
with lib; let cfg = config.euphgh.home.vscode; in
{
  options.euphgh.home.vscode.enable = mkEnableOption "euphgh visual studio code";
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # vim key mode
        vscodevim.vim
        # color theme
        arcticicestudio.nord-visual-studio-code
        # todo highlight
        gruntfuggly.todo-tree
        # icon theme
        pkief.material-icon-theme
        # git
        eamodio.gitlens
        # nix reproduce
        mkhl.direnv
        # path auto complete
        christian-kohler.path-intellisense
        # remote ssh
        ms-vscode-remote.remote-ssh

        # cpp
        llvm-vs-code-extensions.vscode-clangd
        vadimcn.vscode-lldb
        ms-vscode.cmake-tools
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
        # slides
        hediet.vscode-drawio
        redhat.vscode-xml
        mshr-h.veriloghdl
      ];
    };
  };
}
