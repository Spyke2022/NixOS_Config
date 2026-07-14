{ config, pkgs, ... }:

{
  home.username = "silas";
  home.homeDirectory = "/home/silas";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    kitty
    wofi
    hyprpaper
    hyprlock
    dunst
    grim
    slurp
    wl-clipboard
    brightnessctl
    pamixer
    networkmanagerapplet
    nautilus
    python3
  ];

  # ---------- HYPRLAND ----------
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    configType = "hyprlang";

    settings = {
      monitor = ",preferred,auto,1";

      exec-once = [
        "waybar"
        "hyprpaper"
        "dunst"
        "nm-applet --indicator"
      ];

      env = [
        "XCURSOR_THEME,Bibata-Modern-Amber"
        "XCURSOR_SIZE,24"
      ];

      # Teclado interno: ABNT2
      input = {
        kb_layout = "br";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
          tap-to-click = true;
        };
      };

      # Teclado externo HyperX Alloy Elite 2: US Internacional
      device = [
        {
          name = "hp--inc-hyperx-alloy-elite-2-1";
          kb_layout = "us";
          kb_variant = "intl";
        }
        {
          name = "hp--inc-hyperx-alloy-elite-2";
          kb_layout = "us";
          kb_variant = "intl";
        }
      ];

      general = {
        gaps_in = 4;
        gaps_out = 8;
        border_size = 2;
        "col.active_border" = "rgba(cba6f7ee) rgba(89b4faee) 45deg";
        "col.inactive_border" = "rgba(313244aa)";
        layout = "dwindle";
      };

      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
        };
      };

      animations = {
        enabled = true;
        animation = [
          "windows, 1, 4, default"
          "workspaces, 1, 4, default"
          "fade, 1, 4, default"
        ];
      };

      dwindle = {
        preserve_split = true;
      };

      "$mod" = "SUPER";

      bind = [
        "$mod, Return, exec, kitty"
        "$mod, D, exec, wofi --show drun"
        "$mod, Q, killactive"
        "$mod, E, exec, nautilus"
        "$mod, B, exec, google-chrome-stable"
        "$mod, F, fullscreen"
        "$mod, V, togglefloating"
        "$mod, L, exec, hyprlock"
        "$mod SHIFT, M, exit"

        # Menus Garuda Tools
        "$mod, F1, exec, kitty --title 'Forense Digital' -e python3 /home/silas/.local/share/garuda-sway-tools/garuda-forensics-menu.py"
        "$mod, F2, exec, kitty --title 'Produtividade' -e python3 /home/silas/.local/share/garuda-sway-tools/garuda-productivity-menu.py"

        # Lista de atalhos
        "$mod, F3, exec, sh -c 'wofi --dmenu --prompt Atalhos < /home/silas/.local/share/atalhos.txt'"

        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"

        ", Print, exec, grim -g \"$(slurp)\" - | wl-copy"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      ];
    };
  };

  # ---------- WAYBAR ----------
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 32;
      modules-left = [ "hyprland/workspaces" "custom/apps" "custom/atalhos" "custom/forensics" "custom/productivity" "hyprland/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "hyprland/language" "pulseaudio" "network" "battery" "tray" ];

      "hyprland/workspaces" = {
        format = "{id}";
      };

      "custom/apps" = {
        format = "󰀻 Apps";
        tooltip = false;
        on-click = "wofi --show drun";
      };

      "custom/atalhos" = {
        format = "󰌌 Atalhos";
        tooltip = false;
        on-click = "sh -c 'wofi --dmenu --prompt Atalhos < /home/silas/.local/share/atalhos.txt'";
      };

      "custom/forensics" = {
        format = " Forense";
        tooltip = false;
        on-click = "kitty --title 'Forense Digital' -e python3 /home/silas/.local/share/garuda-sway-tools/garuda-forensics-menu.py";
      };

      "custom/productivity" = {
        format = " Produtividade";
        tooltip = false;
        on-click = "kitty --title 'Produtividade' -e python3 /home/silas/.local/share/garuda-sway-tools/garuda-productivity-menu.py";
      };

      "hyprland/language" = {
        format = "  {}";
        format-pt = "BR";
        format-en = "US";
      };

      clock = {
        format = "{:%H:%M  %d/%m/%Y}";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟";
        format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
        on-click = "pamixer -t";
      };

      network = {
        format-wifi = "󰤨 {signalStrength}%";
        format-ethernet = "󰈀";
        format-disconnected = "󰤭";
      };

      battery = {
        format = "{icon} {capacity}%";
        format-icons = [ "󰁺" "󰁼" "󰁾" "󰂀" "󰁹" ];
        states = { warning = 30; critical = 15; };
      };
    }];
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Font Awesome 6 Free";
        font-size: 13px;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        border-bottom: 2px solid #cba6f7;
      }
      #workspaces button {
        color: #cdd6f4;
        padding: 0 8px;
      }
      #workspaces button.active {
        color: #cba6f7;
        border-bottom: 2px solid #cba6f7;
      }
      #custom-apps, #custom-atalhos, #custom-forensics, #custom-productivity {
        padding: 0 10px;
        color: #89b4fa;
      }
      #custom-apps:hover, #custom-atalhos:hover, #custom-forensics:hover, #custom-productivity:hover {
        color: #cba6f7;
      }
      #clock, #battery, #network, #pulseaudio, #language, #tray {
        padding: 0 10px;
      }
      #battery.warning { color: #f9e2af; }
      #battery.critical { color: #f38ba8; }
    '';
  };

  # ---------- LISTA DE ATALHOS ----------
  home.file.".local/share/atalhos.txt".text = ''
    Super+Q             Fechar janela
    Super+Enter         Terminal (kitty)
    Super+D             Menu de apps (wofi)
    Super+E             Gerenciador de arquivos
    Super+B             Chrome
    Super+F             Tela cheia
    Super+V             Janela flutuante
    Super+L             Bloquear tela
    Super+F1            Menu Forense
    Super+F2            Menu Produtividade
    Super+F3            Esta lista de atalhos
    Super+1..5          Ir ao workspace
    Super+Shift+1..5    Mover janela ao workspace
    Super+Setas         Mudar foco entre janelas
    Super+Arrastar(esq) Mover janela
    Super+Arrastar(dir) Redimensionar
    Print               Screenshot regiao -> clipboard
    Super+Shift+M       Sair do Hyprland
  '';

  # ---------- WOFI ----------
  home.file.".config/wofi/config".text = ''
    width=420
    height=480
    location=top_left
    xoffset=8
    yoffset=40
    prompt=Aplicativos
    insensitive=true
    allow_images=true
    image_size=24
  '';

  home.file.".config/wofi/style.css".text = ''
    window {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
    }
    #input {
        margin: 4px;
    }
    #entry {
        padding: 2px 6px;
    }
  '';

  # ---------- KITTY ----------
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      background_opacity = "0.92";
      confirm_os_window_close = 0;
    };
  };

  # ---------- HYPRPAPER ----------
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = /etc/nixos/wallpapers/sddm-background.png
    wallpaper = ,/etc/nixos/wallpapers/sddm-background.png
  '';

  # ---------- GIT ----------
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Spyke2022";
        email = "safalcao@me.com";
      };
    };
  };
}
