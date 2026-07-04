{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./synapse.nix
    ];

  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      # zenpower
    ];
    initrd.kernelModules = [
      "amdgpu"
      "ntsync"
      # "zenpower"
    ];
    kernel.sysctl."kernel.core_pattern" = "/dev/null";
    kernelModules = [ ];
    kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;
    kernelParams = [
      "amd_pstate=active"
      "amdgpu.sg_display=0"
      "mitigations=off"
      "nowatchdog"
      "preempt=full"
      "transparent_hugepage=madvise"
      "iommu=pt"
    ];
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

  documentation = {
    man.cache.enable = false;
    nixos.enable = false;
  };

  environment = {
    binsh = "${pkgs.dash}/bin/dash";
    etc = {
      "xdg/gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-application-prefer-dark-theme=1
        gtk-theme-name=Adwaita-dark
      '';
      "xdg/gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-application-prefer-dark-theme=1
        gtk-theme-name=Adwaita-dark
      '';
    };
    sessionVariables = {
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
      AMD_VULKAN_ICD = "RADV";
      ENABLE_HDR_WSI = "1";
      DXVK_HDR = "1";
      MESA_SHADER_CACHE_MAX_SIZE = "16G";
      NIXOS_OZONE_WL = "1";
      PROTON_ENABLE_HDR = "1";
      PROTON_ENABLE_WAYLAND = "1";
      PROTON_FSR4_UPGRADE = "1";
      PROTON_USE_NTSYNC = "1";
      PROTON_XESS_UPGRADE = "1";
    };
    systemPackages = with pkgs; [
      alacritty
      amdgpu_top
      # android-studio
      # ani-cli
      # antares
      # asmfmt
      # bacon
      # bash
      bc
      btop
      # cargo-outdated
      (cava.override {
        withSDL2 = true;
      })
      cbonsai
      # clang
      # clang-tools
      # claude-code
      # cmake
      cmatrix
      # davinci-resolve
      # discord
      dust
      dualsensectl
      # element-desktop
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
      glab
      gnome-themes-extra
      # gnumake
      gparted
      # grim
      # handbrake
      # heroic
      # htop-vim
      hyprpaper
      jq
      # kdePackages.xwaylandvideobridge
      killall
      # libnotify
      # libreoffice
      # lmstudio
      lsfg-vk
      lsfg-vk-ui
      # lutris
      # mako
      # mangohud
      # mangojuice
      mission-center
      mpv
      # nasm
      # neofetch
      nethogs
      # ninja
      nixpkgs-fmt
      # nodejs_20
      ntfs3g
      nur.repos.Adamekka.gdstash
      # nur.repos.nltch.spotify-adblock
      onefetch
      opencode
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
      signal-desktop
      # slurp
      spotify
      starship
      # stoat-desktop
      sway-contrib.grimshot
      telegram-desktop
      tldr
      tokei
      unzip
      vesktop
      # vim
      vivaldi
      # vlc
      vscode-fhs
      # webcord
      wget
      # wine-staging
      # witr
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
    extraHosts = "0.0.0.0 paradise-s1.battleye.com\n0.0.0.0 test-s1.battleye.com\n0.0.0.0 paradiseenhanced-s1.battleye.com"; # GTA V Multiplayer fix
    firewall = {
      allowedTCPPorts = [
        22 #   SSH
        80 #   HTTP
        443 #  HTTPS
        8188 # ComfyUI
        8448 # Matrix federation
      ];
      enable = false;
    };
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
    substituters = [
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
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
              gtk-application-prefer-dark-theme = true;
              gtk-theme = "Adwaita-dark";
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
    nano.enable = false;
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
        nur.repos.mio.proton-cachyos_x86_64_v3 # v4 was removed
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
    # virt-manager.enable = true;
    waybar.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
    style = "adwaita-dark";
  };

  security = {
    pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "core";
        value = "0";
      }
      {
        domain = "*";
        type = "hard";
        item = "core";
        value = "0";
      }
    ];
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
    coredump.enable = false;
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

  zramSwap = {
    algorithm = "lz4"; # lz4 is fastest; zstd has better compression ratio, but is a bit slower
    enable = true;
    memoryPercent = 200;
  };
}
