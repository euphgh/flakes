{ self, lib, config, ... }:
with lib; let
  cfg = config.euphgh.sys.sops;
  inherit (self.utils) rootPath;
in
{
  options.euphgh.sys.sops.enable = mkEnableOption "sops secrets services";
  config = mkIf cfg.enable {
    sops.defaultSopsFile = rootPath + /secrets/general.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = /home/hgh/.config/sops/age/keys.txt;
    # sops.age.sshKeyPaths = [ "/home/hgh/.ssh/id_ed25519" ];
    # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    # sops.age.generateKey = true;
  };
}
