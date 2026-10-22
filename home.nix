{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nix-dots/dotconf";
  mksymlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{

  home.username = "suika";
  home.homeDirectory = "/home/suika";
  home.stateVersion = "26.05";
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
	identityFile = "~/.ssh/githubkey";
	identitiesOnly = true;
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
  programs.fish = {
    enable = true;
  };
  xdg.configFile."nvim" = {
    source = mksymlink "${dotfiles}/nvim/";
    recursive = true;
  };
}
