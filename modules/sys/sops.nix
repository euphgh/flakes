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
    sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    environment.variables.SOPS_AGE_KEY_FILE = "/run/secrets.d/age-keys.txt";
  };
}
