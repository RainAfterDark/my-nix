{ ... }:
let
  mkAnim = kind: { enable = true; } // { inherit kind; };
  mkShader = kind: custom-shader: (mkAnim kind) // { inherit custom-shader; };

  bounce = {
    spring = {
      damping-ratio = 0.75;
      stiffness = 750;
      epsilon = 0.001;
    };
  };

  stable-crossfade = builtins.readFile ./stable-crossfade.frag.glsl;
  tv-glitch = builtins.readFile ./tv-glitch.frag.glsl;
in
{
  programs.niri.settings = {
    animations = {
      workspace-switch = mkAnim bounce;
      window-movement = mkAnim bounce;
      horizontal-view-movement = mkAnim bounce;

      window-resize = mkShader bounce stable-crossfade;
      window-open = mkShader bounce tv-glitch;
      window-close = mkShader bounce tv-glitch;
    };
  };
}
