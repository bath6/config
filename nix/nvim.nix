{ pkgs, ... }:
{
  
  programs.nixvim = { 
    enable = true;
    defaultEditor = true;

    vimAlias = true;
    viAlias = true;

    opts = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      relativenumber = true;
    };      
    clipboard = {
      providers = {
        wl-copy.enable = true; # Wayland 
      };
      register = "unnamedplus";
    };

  };

}
