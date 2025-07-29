{ config, colors, ... }:
let
  fontFamily = config.stylix.fonts.monospace.name;
in
{
  programs.walker.theme.style = with colors; ''
    @define-color foreground ${base06};
    @define-color background ${base00-rgba 0.95};
    @define-color color1 ${base0D};

    #window,
    #box,
    #aiScroll,
    #aiList,
    #search,
    #password,
    #input,
    #prompt,
    #clear,
    #typeahead,
    #list,
    child,
    scrollbar,
    slider,
    #item,
    #text,
    #label,
    #bar,
    #sub,
    #activationlabel {
      all: unset;
      font-family: "${fontFamily}";
      transition: all 0.3s ease;
    }

    #cfgerr {
      background: rgba(255, 0, 0, 0.4);
      margin-top: 20px;
      padding: 8px;
      font-size: 1.2em;
    }

    #window {
      color: @foreground;
    }

    #box {
      border-radius: 0px;
      background: @background;
      padding: 32px;
      border: 4px solid ${base07};
      box-shadow:
        0 19px 38px rgba(0, 0, 0, 0.3),
        0 15px 12px rgba(0, 0, 0, 0.22);
    }

    #search {
      box-shadow:
        0 1px 3px rgba(0, 0, 0, 0.1),
        0 1px 2px rgba(0, 0, 0, 0.22);
      background: ${base01};
      border: 2px solid ${base0C};
      padding: 8px;
    }

    #prompt {
      margin-left: 4px;
      margin-right: 12px;
      color: @foreground;
      opacity: 0.2;
    }

    #clear {
      color: @foreground;
      opacity: 0.8;
    }

    #password,
    #input,
    #typeahead {
      border-radius: 0px;
    }

    #input {
      background: none;
    }

    #password {
    }

    #spinner {
      padding: 8px;
    }

    #typeahead {
      color: @foreground;
      opacity: 0.8;
    }

    #input placeholder {
      opacity: 0.5;
    }

    #list {
    }

    child {
      padding: 8px;
      border-radius: 0px;
    }

    child:selected,
    child:hover {
      background: alpha(@color1, 0.4);
    }

    #item {
    }

    #icon {
      margin-right: 8px;
    }

    #text {
    }

    #label {
      font-weight: 500;
    }

    #sub {
      opacity: 0.5;
      font-size: 0.8em;
    }

    #activationlabel {
    }

    #bar {
    }

    .barentry {
    }

    .activation #activationlabel {
    }

    .activation #text,
    .activation #icon,
    .activation #search {
      opacity: 0.5;
    }

    .aiItem {
      padding: 10px;
      border-radius: 0px;
      color: @foreground;
      background: @background;
    }

    .aiItem.user {
      padding-left: 0;
      padding-right: 0;
    }

    .aiItem.assistant {
      background: lighter(@background);
    }
  '';
}
