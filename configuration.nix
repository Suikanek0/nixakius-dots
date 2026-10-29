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

#  stylix = {
#    enable = true;
#    image = ./dotconf/wallpapers/current_wallpaper;
#    polarity = "dark";
#    opacity = {
#      terminal = 0.95;
#    };
#   };

  environment.extraInit = ''
    export XDG_DATA_DIRS="$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share"
  '';

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
  programs.starship = {
    enable = true;
    settings = {
      username = {
        show_always = true;
      };
      hostname = {
        ssh_only = false;
      };
    };
  };  
  programs.obs-studio = {
    enable = true;
    package = (
      pkgs.obs-studio.override {
        cudaSupport = true;
      }
    );
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-gstreamer
      obs-vkcapture
    ];
   };
  programs.steam.enable = true;
  programs.umbriel.enable = true;
  programs.ssh.startAgent = true;
  services.gnome.gcr-ssh-agent.enable = false;

# grub bootloader
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
    wine
    easyeffects
    firefox
    gamescope
    gamemode
    bat
    ntfs3g
    nixd
    kew
    rmpc
    mpc
    mpd
    nixfmt
    nicotine-plus
    kitty
    starship
    obsidian
    mpd-mpris
    musicpresence
    mpdscribble
    cava
    tree
    matugen
    yazi
    awww
    peaclock
    lavat
    pipes
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];
    packages = [
      "org.vinegarhq.Sober"
      "me.amankhanna.opendeck"
    ];
    overrides = {
      settings = {
        "org.vinegarhq.Sober" = {
          Context.filesystems = [
            "xdg-run/app/com.discordapp.Discord:create"
            "xdg-run/discord-ipc-0"
          ];
        };
      };
    };

    update.onActivation = true;
   };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

  # Open ports in the firewall.
   networking.firewall.allowedTCPPorts = [ 2234 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # windows disk mount
  fileSystems."/home/suika/windows" = {
    device = "/dev/disk/by-uuid/EE3AD89A3AD860DF";
    fsType = "ntfs3";
    options = [
      "defaults"
      "nofail"
      "uid=1000"
      "gid=100"
      "dmask=0022"
      "fmask=0133"
      "windows_names"
    ];
   };


  services.pipewire = {
    enable = true; # if not already enabled
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment the following
    #jack.enable = true;
  };
# Disable suspend of Toslink output to prevent audio popping.
  services.pipewire.wireplumber.extraConfig."99-disable-suspend" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_input.usb-3142_fifine_Microphone-00.analog-stereo";
          }
          {
            "node.name" = "alsa_output.pci-0000_2d_00.4.analog-stereo";
          }
        ];
        actions = {
          update-props = {
            "session.suspend-timeout-seconds" = 0;
          };
        };
      }
    ];
  };
 # security.rtkit.enable = true;
  system.stateVersion = "26.05"; # Did you read the comment?

}
