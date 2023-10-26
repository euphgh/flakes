{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.euphgh.bluetoothHeadphones;
in
{
  options.euphgh.bluetoothHeadphones.enable = mkEnableOption "bluetooth headphones";
  config = mkIf cfg.enable {
    hardware.bluetooth.enable = true;
    hardware.pulseaudio.enable = true;
  };
}
