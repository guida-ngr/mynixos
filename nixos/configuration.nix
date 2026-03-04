{ config, lib, pkgs, ... }:
{ imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics = { enable = true; enable32Bit = true; };

  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    extraPackages = with pkgs; [
      swww
      swaylock
      swayidle
      xwayland
    ];
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.pipewire = { enable = true; alsa.enable = true; pulse.enable = true; };
  networking.hostName = "nixbtw";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd sway";
        user = "greeter";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  users.users.guidxa = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" ];
    packages = with pkgs; [
      quickshell
      autotiling
      wofi
      kitty
      firefox
      obsidian
      ranger
      kooha
    ];
  };

  programs.firefox = {
    enable = true;
    languagePacks = [ "pt-BR" "en-US" ];
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";};};
      Preferences = {
        "media.gmp-widevinecdm.enabled" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "browser.uidensity" = 1;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    neovim git tree jq unzip coreutils
  ];

  fonts.packages = with pkgs; [
    open-sans
    nerd-fonts.caskaydia-cove
  ];
}
