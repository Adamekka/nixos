{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./synapse.nix
    ];

  boot = {
    initrd.kernelModules = [ "amdgpu" "ntsync" ];
    kernelModules = [ ];
    kernelPackages = pkgs.linuxPackages_cachyos-lto;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  chaotic = {
    hdr = {
      enable = true;
      specialisation.enable = false;
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
      ENABLE_HDR_WSI = "1";
      NIXOS_OZONE_WL = "1";
      PROTON_ENABLE_HDR = "1";
      PROTON_ENABLE_WAYLAND = "1";
      PROTON_FSR4_UPGRADE = "1";
      PROTON_USE_NTSYNC = "1";
      PROTON_XESS_UPGRADE = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
    systemPackages = with pkgs; [
      alacritty
      # android-studio
      # antares
      # asmfmt
      ani-cli
      # bacon
      # bash
      btop
      # cargo-outdated
      (cava.override {
        withSDL2 = true;
      })
      cbonsai
      clang
      clang-tools
      # cmake
      cmatrix
      # davinci-resolve
      # discord
      dust
      dualsensectl
      element-desktop
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
      lsfg-vk-ui
      # lutris
      # mako
      mangohud
      mangojuice
      mission-center
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
      prismlauncher
      protonup-qt
      python3Minimal
      qbittorrent
      ripgrep
      rofi
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
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      nerd-fonts.ubuntu-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      ubuntu-classic
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
      extraPackages = with pkgs; [ ];
    };
  };

  networking = {
    # firewall.enable = false;
    hostName = "nixos";
    networkmanager.enable = true;
    wireless.userControlled = true;
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
    permittedInsecurePackages = [ ];
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
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        obs-vaapi
        obs-vkcapture
        wlrobs
      ];
    };
    steam = {
      dedicatedServer.openFirewall = true;
      enable = true;
      extest.enable = true;
      extraCompatPackages = with pkgs; [
        nur.repos.mio.proton-cachyos_x86_64_v4
        proton-ge-bin
      ];
      gamescopeSession.enable = true;
      protontricks.enable = true;
      remotePlay.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs; [ ];
    };
    virt-manager.enable = true;
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
    flatpak.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    gnome.gnome-keyring.enable = true;
    irqbalance.enable = true;
    lact.enable = true;
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
    tumbler.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
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

  virtualisation = {
    # docker.enable = true;
    libvirtd.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
    ];
  };
}
