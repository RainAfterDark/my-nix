{ config, ... }:
{
  services.swaync = {
    enable = true;

    settings = {
      positionY = "top";
      positionX = "right";
      layer = "top";
      control-center-margin-top = 4;
      control-center-margin-right = 8;
      notification-2fa-action = false;
      notification-inline-replies = true;
      timeout = 5;
      timeout-low = 2;
      control-center-width = 400;
      control-center-height = 600;
      fit-to-screen = false;
      notification-window-width = 400;
      transition-time = 500;
      hide-on-clear = true;

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

    style =
      let
        colors = config.lib.stylix.colors;
        rgba =
          base: a:
          let
            c = n: builtins.getAttr (base + "-rgb-" + n) colors;
          in
          "rgba(${c "r"}, ${c "g"}, ${c "b"}, ${toString a})";
      in
      with colors;
      ''
        * {
         border-radius: 0px;
        }

        /* -----------------------------
            Global Notification Elements
            ----------------------------- */

        /* The container row for all notification elements. */
        .notification-row {
          outline: none;
        }

        /* The background element: acts as a box behind the notification. */
        .notification-background {
          padding: 4px 6px;
        }

        /* The main notification box that contains actions and content. */
        .notification {
          border: 2px solid #${base07};
          margin-top: 1px;
          margin-right: 12px;
          margin-left: 12px;
          padding: 0;
          background: ${rgba "base02" 0.85};
          box-shadow:
            0 0 0 1px ${rgba "base01" 0.3},
            0 1px 3px 1px ${rgba "base01" 0.7},
            0 2px 6px 2px ${rgba "base01" 0.3};
        }

        /* For desktop notifications that are not part of a panel. */
        .floating-notifications {
          background: transparent;
        }

        /* The main content area for notification text (like messages). */
        .notification-content {
          background: transparent;
          padding: 10px;
        }

        /* Default action elements, such as a Telegram message. */
        .notification-default-action {
          padding: 4px;
          margin: 0;
          background: transparent;
          border: none;
          color: #${base05};
        }

        .notification-default-action:hover {
          -gtk-icon-effect: none;
          background: ${rgba "base01" 0.85};
        }

        /* Actions such as "Mark as read". */
        .notification-action {
          padding: 4px;
          margin: 0;
          background: transparent;
          color: #${base05};
          border: none;
          border-top:    1px solid #${base02};
          border-right:  1px solid #${base02};
        }

        .notification-action:hover {
          -gtk-icon-effect: none;
          background: ${rgba "base01" 0.85};
        }

        /* ----------------------
            Inline Reply Elements
            ---------------------- */

        .inline-reply {
          margin-top: 4px;
        }

        .inline-reply-entry {
          background: ${rgba "base01" 0.85};
          color: #${base05};
          caret-color: #${base05};
          border: transparent;
        }

        .inline-reply-button {
          margin-left: 4px;
          background: transparent;
          border: 1px solid ${rgba "base03" 0.85};
          color: #${base05};
        }

        .inline-reply-button:disabled {
          background: transparent;
          color: #${base03};
          border-color: transparent;
        }

        .inline-reply-button:hover {
          background: ${rgba "base02" 0.85};
        }

        /* ------------------------------
            Notification Control Elements
            ------------------------------ */

        .close-button {
          background: transparent;
          color: #${base05};
          border-radius: 100%;
          margin-top: 5px;
          margin-right: 16px;
          min-width: 24px;
          min-height: 24px;
        }

        .close-button:hover {
          background: ${rgba "base02" 0.85};
        }

        /* ---------------------------
            Icons and Summary Elements
            --------------------------- */

        .image {
          -gtk-icon-effect: none;
          border-radius: 100px;
          margin: 4px;
        }

        .app-icon {
          -gtk-icon-effect: none;
          -gtk-icon-shadow: 0 1px 4px black;
          margin: 6px;
        }

        .summary {
          font-size: 14px;
          font-weight: bold;
          background: transparent;
          color: #${base05};
        }

        .time {
          font-size: 14px;
          font-weight: bold;
          background: transparent;
          color: #${base05};
        }

        .body {
          font-size: 12px;
          font-weight: normal;
          background: transparent;
          color: #${base05};
          margin-top: 5px;
        }

        .body-image {
          margin-top: 4px;
          background-color: #${base07};
          -gtk-icon-effect: none;
        }

        /* ----------------------------
            Control Center and Grouping
            ---------------------------- */

        .control-center {
          background: ${rgba "base00" 0.85};
          color: #${base05};
          border: 3px solid #${base07};
          box-shadow: 0px 0px 25px rgba(0, 0, 0, 0.3);
          margin-left: 6px;
        }

        .control-center-list-placeholder {
          opacity: 0.5;
        }

        .control-center-list {
          background: transparent;
        }

        .blank-window {
          background: transparent;
        }

        .notification-group-buttons,
        .notification-group-headers {
          margin: 0 16px;
          color: #${base05};
        }

        .notification-group-icon {
          color: #${base05};
        }

        .notification-group-header {
          color: #${base05};
        }

        /* ---------------
            Widget Styling
            --------------- */

        .widget-title {
          color: #${base05};
          margin: 8px 12px;
          font-size: 20px;
        }

        .widget-title > button {
          font-size: 16px;
          color: #${base05};
          text-shadow: none;
          background: ${rgba "base01" 0.85};
          border: 1px solid ${rgba "base03" 0.85};
        }

        .widget-title > button:hover {
          background: ${rgba "base02" 0.85};
        }

        .widget-dnd {
          color: #${base05};
          margin: 0px 12px;
          font-size: 1.1rem;
        }

        .widget-dnd > switch {
          font-size: initial;
          background: ${rgba "base01" 0.85};
          border: 1px solid ${rgba "base03" 0.85};
          box-shadow: none;
        }

        .widget-dnd > switch:checked {
          background: ${rgba "base09" 0.85};
        }

        .widget-dnd > switch slider {
          background: ${rgba "base02" 0.85};
        }

        .widget-volume {
          color: #${base05};
          background-color: ${rgba "base01" 0.85};
          padding: 8px;
          margin: 8px;
        }

        .widget-backlight {
          color: #${base05};
          background-color: ${rgba "base01" 0.85};
          padding: 8px;
          margin: 8px;
        }
      '';
  };
}
