{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Africa/Nairobi";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a User account(s)
  users.users.enigma = { # my user
    isNormalUser = true;
    description = "enigma";
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [];

  };

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

   # Packages
  environment.systemPackages = [
    pkgs.neovim              # texteditor of choice
    pkgs.wget
    pkgs.tree
    pkgs.btop                # system resource monitor

    pkgs.docker              # docker
    pkgs.docker-compose

    pkgs.fail2ban            # handle brute force access attacks
    pkgs.nix-ld              # enable other linux app support
    pkgs.git                 # version control

  ];

  # Docker
  virtualisation.docker = {
    enable = true;
  };

  # SSH
  services.openssh = {
    enable = true;
    ports = [213];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  # Firewall.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      213        # ssh local
    ];
    allowedUDPPorts = [
    
    ];
  };
  
  # Keep awake
  services.logind.extraConfig = ''
    HandleLidSwitch=ignore
    HandleLidSwitchDocked=ignore
    IdleAction=ignore
  '';


  # Security
  services.fail2ban.enable = true;


  # Garbage collection  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 8d";
  };
  #nix.optimise.automatic = true; # look at it later


  # Package support
  programs.nix-ld.enable = true;


  system.stateVersion = "24.11";
}