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
    kernelPackages = pkgs.linuxPackages_latest;
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
      asmfmt
      bacon
      # bash
      bat
      btop
      # cargo-outdated
      cava
      cbonsai
      clang
      clang-tools
      # cmake
      cmatrix
      # davinci-resolve
      # discord
      du-dust
      etterna
      # eww
      eza
      fd
      ffmpeg
      fish
      flameshot
      fzf
      gcc
      gh
      # gimp
      git
      git-lfs
      github-desktop
      gnumake
      gparted
      # grim
      # handbrake
      heroic
      # htop-vim
      kdePackages.xwaylandvideobridge
      killall
      # libnotify
      # libreoffice
      lutris
      mako
      # mangohud
      mpv
      nasm
      neofetch
      neovim
      nethogs
      # ninja
      nixpkgs-fmt
      # nodejs_20
      ntfs3g
      # nur.repos.nltch.spotify-adblock
      obs-studio
      onefetch
      osu-lazer-bin
      p7zip
      pavucontrol
      pfetch
      playerctl
      # prismlauncher
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
      vesktop
      # vim
      vivaldi
      # vlc
      vscode-fhs
      (pkgs.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      # webcord
      wget
      # wine-staging
      xfce.thunar
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
    bluetooth = {
      enable = true;
      package = pkgs.bluez.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [
          "--enable-sixaxis"
        ];
      });
      powerOnBoot = true;
      input.General.ClassicBondedOnly = false;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  networking = {
    firewall.enable = false;
    hostName = "nixos";
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
      # "openssl-1.1.1u"
      # "openssl-1.1.1v"
      # "qbittorrent-4.6.4"
    ];
  };

  programs = {
    adb.enable = true;
    fish.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    nh = {
      clean = {
        enable = true;
        extraArgs = "--keep-since 14d --keep 15";
      };
      enable = true;
      flake = "/etc/nixos";
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [ ];
    };
    steam = {
      dedicatedServer.openFirewall = true;
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
    # virt-manager.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    accounts-daemon.enable = true;
    dbus.enable = true;
    displayManager = {
      sessionPackages = with pkgs; [
        hyprland
      ];
      sddm.enable = true;
    };
    # flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    libinput.enable = true;
    # openssh = {
    #   enable = true;
    #   settings.PasswordAuthentication = true;
    # };
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
    pulseaudio.support32Bit = true;
    tailscale.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      windowManager.awesome.enable = true;
      xkb.layout = "us";
    };
  };

  system = {
    copySystemConfiguration = false;
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

  # virtualisation = {
  #   docker.enable = true;
  #   libvirtd.enable = true;
  # };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
}
