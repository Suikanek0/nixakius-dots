{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nix-dots/dotconf";
  mksymlink = path: config.lib.file.mkOutOfStoreSymlink path;
in

{

  home.username = "suika";
  home.homeDirectory = "/home/suika";
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Suikanek0";
	email = "dargaigor5@icloud.com";
     };
    }; 
  };
  home.stateVersion = "26.05";
  xdg.configFile."nvim" = {
    source = mksymlink "${dotfiles}/nvim/";
    recursive = true;
  };
}
