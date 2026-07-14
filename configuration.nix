{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Recife";

  i18n.defaultLocale = "pt_BR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.enable = true;

  # SDDM + Plasma (mantidos; Hyprland aparece como sessao extra)
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    settings = {
      Theme = {
        Background = "/etc/nixos/wallpapers/sddm-background.png";
      };
    };
  };

  services.desktopManager.plasma6.enable = true;

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Teclado: ABNT2 + US Internacional (Plasma/SDDM/X11)
  services.xserver.xkb = {
    layout = "br,us";
    variant = ",intl";
    options = "grp:win_space_toggle";
  };

  environment.sessionVariables = {
    XKB_DEFAULT_LAYOUT = "br,us";
    XKB_DEFAULT_VARIANT = ",intl";
    XKB_DEFAULT_OPTIONS = "grp:win_space_toggle";
    XCURSOR_THEME = "Bibata-Modern-Amber";
    XCURSOR_SIZE = "24";
  };

  console.keyMap = "br-abnt2";

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.silas = {
    isNormalUser = true;
    description = "silas";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Home Manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.silas = import ./home.nix;
    backupFileExtension = "hm-backup";
  };

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

  programs.bash.interactiveShellInit = ''
    fastfetch
  '';

  environment.systemPackages = with pkgs; [
    bibata-cursors
    bluez
    bluez-tools
    efibootmgr
    google-chrome
    fastfetch
    git
    gh
    libreoffice
    thunderbird
  ];

  system.stateVersion = "25.11";

}
