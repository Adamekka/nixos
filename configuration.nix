{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./secret.nix
    ];

  boot = {
    kernelModules = [ "nvidia_uvm" ];
    loader.systemd-boot.enable = true;
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
    systemPackages = with pkgs; [
      alacritty
      # android-studio
      # bacon
      # bash
      bat
      btop
      # cargo-outdated
      cava
      cbonsai
      # cmake
      cmatrix
      # davinci-resolve
      discord
      du-dust
      # eww
      eza
      fd
      ffmpeg
      fish
      fzf
      # gcc
      gh
      gimp
      git
      git-lfs
      github-desktop
      # gnumake
      gparted
      # grim
      # handbrake
      heroic
      # htop-vim
      killall
      # libnotify
      libreoffice
      lutris
      mako
      # mangohud
      mpv
      neofetch
      neovim
      nethogs
      # ninja
      nixpkgs-fmt
      # nodejs_20
      # ntfs3g
      # nur.repos.nltch.spotify-adblock
      nvtopPackages.full
      obs-studio
      onefetch
      osu-lazer-bin
      pavucontrol
      pfetch
      playerctl
      prismlauncher
      protonup-qt
      python3Full
      qbittorrent
      ripgrep
      rofi-wayland
      # rustup
      sccache
      # slurp
      spotify
      starship
      sway-contrib.grimshot
      telegram-desktop
      tldr
      unzip
      # vim
      vivaldi
      # vlc
      vscode-fhs
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      wget
      wine-staging
      xfce.thunar
      xwaylandvideobridge
      # zellij
      zip
      zulu8
    ];
  };

  fonts = {
    packages = with pkgs; [
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      noto-fonts-extra
      ubuntu_font_family
      pkgs.nerd-fonts._0xproto
      pkgs.nerd-fonts.droid-sans-mono
    ];
  };

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
    };
    permittedInsecurePackages = [
      #"openssl-1.1.1u"
      "openssl-1.1.1v"
    ];
  };

  programs = {
    adb.enable = true;
    fish.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [ ];
    };
    steam = {
      enable = true;
      dedicatedServer.openFirewall = true;
      remotePlay.openFirewall = true;
    };
    virt-manager.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    accounts-daemon.enable = true;
    dbus.enable = true;
    displayManager.sessionPackages = with pkgs; [
      hyprland
    ];
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
    };
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
    tailscale.enable = true;
    xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
      videoDrivers = [ "nvidia" ];
      xkb.layout = "us";
    };
  };

  sound.enable = true;

  system = {
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
    extraGroups = [
      "adbusers"
      "docker"
      "libvirtd"
      "wheel"
    ];
    isNormalUser = true;
    shell = pkgs.fish;
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
