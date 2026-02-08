{ pkgs, lib, ... }:
{
  home.sessionVariables = {
    GLFW_IM_MODULE = "ibus";
  };

  stylix.targets.fcitx5.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";

    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];

      settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
        };

        # Mostly default, only changed main trigger key
        globalOptions = {
          Hotkey = {
            # Enumerate when holding modifier of Toggle key
            EnumerateWithTriggerKeys = "True";
            # Enumerate Input Method Forward
            EnumerateForwardKeys = "";
            # Enumerate Input Method Backward
            EnumerateBackwardKeys = "";
            # Skip first input method while enumerating
            EnumerateSkipFirst = "False";
            # Time limit in milliseconds for triggering modifier key shortcuts
            ModifierOnlyKeyTimeout = "250";
          };

          "Hotkey/TriggerKeys" = {
            "0" = "Control+Super+space";
            "1" = "Zenkaku_Hankaku";
            "2" = "Hangul";
          };

          "Hotkey/ActivateKeys" = {
            "0" = "Hangul_Hanja";
          };

          "Hotkey/DeactivateKeys" = {
            "0" = "Hangul_Romaja";
          };

          "Hotkey/AltTriggerKeys" = {
            "0" = "Shift_L";
          };

          "Hotkey/EnumerateGroupForwardKeys" = {
            "0" = "Super+space";
          };

          "Hotkey/EnumerateGroupBackwardKeys" = {
            "0" = "Shift+Super+space";
          };

          "Hotkey/PrevPage" = {
            "0" = "Up";
          };

          "Hotkey/NextPage" = {
            "0" = "Down";
          };

          "Hotkey/PrevCandidate" = {
            "0" = "Shift+Tab";
          };

          "Hotkey/NextCandidate" = {
            "0" = "Tab";
          };

          "Hotkey/TogglePreedit" = {
            "0" = "Control+Alt+P";
          };

          Behavior = {
            # Active By Default
            ActiveByDefault = "False";
            # Reset state on Focus In
            resetStateWhenFocusIn = "No";
            # Share Input State
            ShareInputState = "No";
            # Show preedit in application
            PreeditEnabledByDefault = "True";
            # Show Input Method Information when switch input method
            ShowInputMethodInformation = "True";
            # Show Input Method Information when changing focus
            showInputMethodInformationWhenFocusIn = "False";
            # Show compact input method information
            CompactInputMethodInformation = "True";
            # Show first input method information
            ShowFirstInputMethodInformation = "True";
            # Default page size
            DefaultPageSize = "5";
            # Override XKB Option
            OverrideXkbOption = "False";
            # Custom XKB Option
            CustomXkbOption = "";
            # Force Enabled Addons
            EnabledAddons = "";
            # Force Disabled Addons
            DisabledAddons = "";
            # Preload input method to be used by default
            PreloadInputMethod = "True";
            # Allow input method in the password field
            AllowInputMethodForPassword = "False";
            # Show preedit text when typing password
            ShowPreeditForPassword = "False";
            # Interval of saving user data in minutes
            AutoSavePeriod = "30";
          };
        };

        addons.classicui.globalSection = {
          PreferTextIcon = "True";
          UseDarkTheme = lib.mkForce "False";
          UseAccentColor = lib.mkForce "False";
        };
      };
    };
  };
}
