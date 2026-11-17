{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Group content: every configured keyboard layout first, then Pinyin,
  # which is always the default input method.
  inputMethods = map (layout: "keyboard-${layout}") config.mg.fcitx5.keyboards ++ [ "pinyin" ];
  items = lib.listToAttrs (
    lib.imap0 (i: name: lib.nameValuePair "Groups/0/Items/${toString i}" { Name = name; }) inputMethods
  );
in
{
  options.mg.fcitx5.keyboards = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [
      "us"
      "pl"
    ];
    description = "Keyboard layouts added to the fcitx5 group before the Pinyin input method";
  };

  config = {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs.qt6Packages; [
          fcitx5-chinese-addons
          fcitx5-configtool
        ];
        # Register via the Wayland input-method protocol: KWin launches
        # fcitx5 as the Plasma virtual keyboard (System Settings -> Virtual
        # keyboard -> "Fcitx 5").
        waylandFrontend = true;
        # Windows MS-Pinyin parity: tapping either Shift alone (within
        # ModifierOnlyKeyTimeout) toggles between Chinese and English.
        # fcitx5 serializes key lists as indexed entries in a dedicated
        # section ([Hotkey/AltTriggerKeys] with 0=..., 1=...), NOT as a
        # comma-joined value under [Hotkey] — that parses as an empty list.
        settings.globalOptions."Hotkey/AltTriggerKeys" = {
          "0" = "Shift_L";
          "1" = "Shift_R";
        };
        settings.inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            # NOTE: fcitx5 expects "Default Layout" (with a space) — a
            # mismatched key silently drops the whole group at load time.
            "Default Layout" =
              if config.mg.fcitx5.keyboards == [ ] then "us" else lib.head config.mg.fcitx5.keyboards;
            DefaultIM = "pinyin";
          };
        }
        // items;
      };
    };

    # KWin launches fcitx5 itself; this autostart service must never run,
    # or the two instances race for the Wayland input-method socket.
    systemd.user.services.fcitx5-daemon.Install.WantedBy = lib.mkForce [ ];

    # WARNING (Plasma Wayland): never restart a running fcitx5 (tray menu
    # "Restart" or `fcitx5-remote -r`). The self-restart re-execs without the
    # socket KWin granted at launch, leaving fcitx5 alive but connected to no
    # input contexts (dead Ctrl+Space). Recovery: `pkill -x fcitx5` + re-login.

    # IME environment for session apps (KDE sources plasma-workspace/env/*).
    # XWayland XIM apps need XMODIFIERS; SDL/GLFW cover games and kitty.
    xdg.configFile."plasma-workspace/env/fcitx5.sh".text = ''
      export XMODIFIERS=@im=fcitx
      export SDL_IM_MODULE=fcitx
      export GLFW_IM_MODULE=ibus
    '';
  };
}
