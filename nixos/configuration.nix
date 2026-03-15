{ config, lib, pkgs, inputs, ...}:
{ imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "25.11";
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true; 
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };
  qt.enable = true;
  
  # boot/driver
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics = { enable = true; enable32Bit = true; };
  hardware.cpu.amd.updateMicrocode = true;
  # network
  networking.hostName = "nixbtw";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # geo
  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";
  # WM
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    extraPackages = with pkgs; [
      swaylock
      swayidle
      xwayland
      qt5.qtwayland
      qt6.qtwayland
    ];
  };
  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland;xcb"; # Try Wayland first, fallback to X11
    GDK_BACKEND = "wayland,x11";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };
  # DM
  services.displayManager.ly = {
    enable = true;
    settings.save = true;
  };
  services.displayManager.defaultSession = "sway";
  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # users
  users.users.guidxa = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "kvm" ];
    packages = with pkgs; [
      inputs.quickshell.packages.${pkgs.system}.default
      autotiling
      kitty
      wofi swww fastfetch btop
      firefox obsidian sioyek
      ranger ueberzugpp imagemagick
      android-studio
      prismlauncher
    ] ++ [
      networkmanagerapplet
      pavucontrol
      vlc
      kooha
      wl-clipboard grim slurp
      playerctl
    ] ++ [
      wineWow64Packages.stable
      winetricks
      bottles 
      mangohud 
      protonup-qt
    ];
  };

  ## pkgs ##
  # browser
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
  # spicetify
  programs.spicetify =
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in
  {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [ adblock shuffle hidePodcasts ];
    theme = spicePkgs.themes.lucid;
  };
  # environment
  environment.systemPackages = with pkgs; [
    neovim git curl
    jq zulu17 zulu21
    killall tree
    coreutils usbutils unzip unrar
    pulseaudio
  ];
  # fonts
  fonts.packages = with pkgs; [
    open-sans
    nerd-fonts.caskaydia-cove
    nerd-fonts.jetbrains-mono
  ];
}
