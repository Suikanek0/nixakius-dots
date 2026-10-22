{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix/cachix.nix
    inputs.umbriel.nixosModules.default
  ];

  # experimental func
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # nvidia
  hardware.nvidia = {
    open = true;
    nvidiaSettings = true;
    videoAcceleration = true;
    modesetting.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # programs
  programs.steam.enable = true;
  programs.umbriel.enable = true;
  programs.ssh.startAgent = true;
  services.gnome.gcr-ssh-agent.enable = false;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    grub = {
      enable = true;
      useOSProber = true;
      copyKernels = true;
      efiSupport = true;
      devices = [ "nodev" ];
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "video=DP-1:1920x1080@180" ];

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixlarp"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "pl";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "pl2";

  # Greeter
  services.displayManager.ly.enable = true;

  # DE/WM x11
  services.xserver = {
    enable = true;
    autoRepeatDelay = 400;
    autoRepeatInterval = 55;
  };
  services.xserver.desktopManager.xfce.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."suika" = {
    isNormalUser = true;
    description = "suika";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    fastfetch
    git
    efibootmgr
    vesktop
    xauth
    xorg-server
    firefox
    gamescope
    gamemode
    bat
    ntfs3g
    nixd
    kew
    nixfmt
    fish
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "26.05"; # Did you read the comment?

}
