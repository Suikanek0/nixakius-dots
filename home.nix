{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixakius-dots/dotconf";
  mksymlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{

  home.username = "suika";
  home.homeDirectory = "/home/suika";
  home.stateVersion = "26.05";
  programs.ssh = {
    enable = true;
    settings = {
      "github.com" = {
        hostname = "github.com";
	identityFile = "~/.ssh/githubkey";
	identitiesOnly = true;
    };
   };
  };
  services.mpd = {
    enable = true;
    musicDirectory = "/home/suika/windows/Music/DAP";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
    '';
    network.listenAddress = "127.0.0.1";
    network.port = 6600;
  };

  services.awww.enable = true;
  programs.vicinae = {
    enable = true;
    systemd = {
      enable = true;
      environment = {
        USE_LAYER_SHELL = 1;
      };
     };
   };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Suikanek0";
	email = "dargaigor5@icloud.com";
     };
    }; 
  };

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  xdg.configFile."nvim" = {
    source = mksymlink "${dotfiles}/nvim";
    recursive = true;
  };

  xdg.configFile."umbriel" = {
    source = mksymlink "${dotfiles}/umbriel";
    recursive = true;
  };

  xdg.configFile."kitty" = {
    source = mksymlink "${dotfiles}/kitty";
    recursive = true;
  };

  xdg.configFile."rmpc" = {
    source = mksymlink "${dotfiles}/rmpc";
    recursive = true;
  };

  xdg.configFile."matugen" = {
    source = mksymlink "${dotfiles}/matugen";
    recursive = true;
  };

  xdg.configFile."mpd" = {
    source = mksymlink "${dotfiles}/mpd";
    recursive = true;
  };


  xdg.dataFile."vicinae/themes/matugen.toml" = {
    source = mksymlink "${dotfiles}/vicinae/themes/matugen.toml";
    recursive = true;
  };

}
