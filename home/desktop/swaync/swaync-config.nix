{ ... }:
{
  services.swaync = {
    enable = true;
    settings = {
      positionY = "top";
      positionX = "right";
      layer = "top";

      control-center-margin-top = 8;
      control-center-margin-right = 12;
      control-center-width = 400;
      control-center-height = 600;
      notification-window-width = 400;

      notification-2fa-action = false;
      notification-inline-replies = true;
      fit-to-screen = false;
      hide-on-clear = true;

      transition-time = 500;
      timeout = 5;
      timeout-low = 2;

      widgets = [
        "inhibitors"
        "title"
        "dnd"
        "notifications"
      ];

      widget-config = {
        inhibitors = {
          text = "Inhibitors";
          button-text = "Clear All";
          clear-all-button = true;
        };
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
      };
    };
  };
}
