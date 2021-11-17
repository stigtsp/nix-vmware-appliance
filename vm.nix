{ pkgs, ... }: {
  imports = [ ./service.nix ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  virtualisation.memorySize = 500;
  nixos-shell.mounts = {
    mountHome = false;
    mountNixProfile = false;
    cache = "none"; # default is "loose"

  };
  services.mojo-app = {
    enable=true;
  };
#  services.convos.enable=true;
}
