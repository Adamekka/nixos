{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./secret.nix
    ];

  boot = {
    initrd.kernelModules = [ "ntsync" ];
    kernelModules = [
      "nvidia_uvm"
      "rtl8821ce"
    ];
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  console = {
    font = "ter-118b";
    packages = [
      pkgs.terminus_font
    ];
    useXkbConfig = true;
  };

  documentation.nixos.enable = false;

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
    systemPackages = with pkgs; [
      alacritty
      # android-studio
      # asmfmt
      # bacon
      # bash
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
      fastfetch
      fd
      ffmpeg
      # flameshot
      fzf
      gh
      # gimp
      github-desktop
      gnumake
      gparted
      # grim
      # handbrake
      # heroic
      # htop-vim
      hyprpaper
      # kdePackages.xwaylandvideobridge
      killall
      # libnotify
      # libreoffice
      lutris
      # mako
      # mangohud
      mpv
      # nasm
      neofetch
      nethogs
      # ninja
      nixpkgs-fmt
      # nodejs_20
      ntfs3g
      # nur.repos.nltch.spotify-adblock
      # onefetch
      osu-lazer-bin
      p7zip
      pavucontrol
      # pfetch
      # prismlauncher
      protonup-qt
      python3Minimal
      qbittorrent
      ripgrep
      rofi-wayland
      # rustup
      # sccache
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
      (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      }))
      # webcord
      wget
      # wine-staging
      # zellij
      zip
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
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      nerd-fonts.ubuntu-mono
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

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "flakes"
      "nix-command"
    ];
    warn-dirty = false;
  };

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # "openssl-1.1.1u"
      # "openssl-1.1.1v"
      # "qbittorrent-4.6.4"
    ];
  };

  programs = {
    # adb.enable = true;
    bat.enable = true;
    dconf = {
      enable = true;
      profiles.user.databases = [
        {
          lockAll = true;
          settings = {
            "org/gnome/desktop/interface" = {
              accent-color = "teal";
              color-scheme = "prefer-dark";
            };
            "org/gnome/mutter" = {
              experimental-features = [
                "scale-monitor-framebuffer"
                "variable-refresh-rate"
                "xwayland-native-scaling"
              ];
            };
          };
        }
      ];
    };
    fish.enable = true;
    gamemode.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    nh = {
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 20";
      };
      enable = true;
      flake = "/etc/nixos";
    };
    nix-ld = {
      enable = true;
      libraries = with pkgs; [ ];
    };
    obs-studio.enable = true;
    steam = {
      dedicatedServer.openFirewall = true;
      enable = true;
      extest.enable = true;
      gamescopeSession.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs; [ ];
    };
    # virt-manager.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo.enable = false;
    sudo-rs = {
      enable = true;
      execWheelOnly = true;
      wheelNeedsPassword = true;
    };
  };

  services = {
    accounts-daemon.enable = true;
    blueman.enable = true;
    dbus.enable = true;
    displayManager = {
      sessionPackages = with pkgs; [
        hyprland
      ];
      sddm.enable = true;
    };
    # flatpak.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    irqbalance.enable = true;
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
    playerctld.enable = true;
    # printing.enable = true;
    pulseaudio.support32Bit = true;
    scx.enable = true;
    # tailscale.enable = true;
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
