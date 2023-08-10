{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;

  environment = {
    sessionVariables = {
      WLR_NO_HARDWARE_CURSORS = "1";
      NIXOS_OZONE_WL = "1";
    };
    systemPackages = with pkgs; [
      alacritty
      bacon
      bash
      bat
      btop
      cava
      clang
      cmake
      cmatrix
      discord
      du-dust
      eww
      exa
      fd
      fish
      fzf
      gcc
      gh
      gimp
      git
      github-desktop
      gnumake
      handbrake
      hyprland
      libnotify
      mako
      mangohud
      neofetch
      neovim
      nethogs
      ninja
      nixpkgs-fmt
      # nur.repos.nltch.spotify-adblock
      nvtop
      obs-studio
      onefetch
      pfetch
      protonup-qt
      python3Full
      ripgrep
      rofi-wayland
      rustup
      sccache
      # spotify
      starship
      steam
      sway-contrib.grimshot
      telegram-desktop
      tldr
      unzip
      vim
      vivaldi
      vscode-fhs
      waybar
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      wget
      wine
      xfce.thunar
      zellij
    ];
  };

  fonts = {
    packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      ubuntu_font_family
      (nerdfonts.override { fonts = [ "FiraCode" "UbuntuMono" ]; })
    ];
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      enable = true;
    };
    pulseaudio.support32Bit = true;
  };

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
    wireless.userControlled.enable = true;
  };

  nixpkgs.config = {
    allowUnfree = true;
    # packageOverrides = pkgs: {
    #   nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
    #     inherit pkgs;
    #   };
    # };
    permittedInsecurePackages = [
      #"openssl-1.1.1u"
      "openssl-1.1.1v"
    ];
  };

  programs = {
    fish.enable = true;
    hyprland = {
      enable = true;
      nvidiaPatches = true;
      xwayland = {
        enable = true;
        hidpi = true;
      };
    };
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    dbus.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    pipewire = {
      alsa = {
        enable = true;
        support32Bit = true;
      };
      enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
    printing.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
        sessionPackages = with pkgs; [
          hyprland
        ];
      };
      layout = "us";
      libinput.enable = true;
      videoDrivers = [ "nvidia" ];
    };
  };

  sound.enable = true;

  system = {
    autoUpgrade = {
      allowReboot = true;
      channel = "https://channels.nixos.org/nixos-unstable";
      enable = true;
    };
    copySystemConfiguration = true;
    stateVersion = "23.05";
  };

  systemd = {
    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
    user.services.polkit-gnome-authentication-agent-1 = {
      after = [ "graphical-session.target" ];
      description = "polkit-gnome-authentication-agent-1";
      serviceConfig = {
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
        Type = "simple";
      };
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
    };
  };

  time.timeZone = "Europe/Prague";

  users.users.adamekka = {
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    shell = pkgs.fish;
  };

  virtualisation.libvirtd.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
