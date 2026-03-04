{ ... }:
let
  duration-ms = 300;

  # Modified version of Burn My Windows's TV Glitch effect
  glitchFrag = ''
    // General animation consts
    const float U_SCALE    = 1.0;
    const float U_STRENGTH = 2.0;
    const float U_SPEED    = 2.0;
    const float U_DURATION = ${toString (duration-ms / 1000.0)};

    // RGB + Scanline consts
    const float RGB_SEPARATION = 0.02;
    const float SCANLINE_VISIBILITY = 0.08;
    const float SCANLINE_DENSITY = 400.0;

    // TV Spark consts
    const float SPARK_BRIGHTNESS = 9.0;
    const float SPARK_DELAY_EXP = 3.0;

    // TV Squish consts
    const float BLUR_WIDTH = 0.01;
    const float TB_TIME    = 0.7;
    const float LR_TIME    = 0.4;
    const float LR_DELAY   = 0.6;
    const float FF_TIME    = 0.1;
    const float SCALING    = 0.5;

    // Helpers
    float easeInQuad(float t) { return t * t; }

    float easeOutQuad(float t) { return t * (2.0 - t); }

    float hash12(vec2 p) {
      vec3 p3  = fract(vec3(p.xyx) * 0.1031);
      p3 += dot(p3, p3.yzx + 33.33);
      return fract((p3.x + p3.y) * p3.z);
    }

    float noise2D(vec2 st) {
      vec2 i = floor(st);
      vec2 f = fract(st);
      float a = hash12(i);
      float b = hash12(i + vec2(1.0, 0.0));
      float c = hash12(i + vec2(0.0, 1.0));
      float d = hash12(i + vec2(1.0, 1.0));
      vec2 u = f * f * (3.0 - 2.0 * f);
      return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
    }

    // Main effect
    vec4 glitch(vec3 coords_geo, vec3 size_geo, float progress) {
      float uSeed = niri_random_seed;

      // Delay the TV squish to the second half of the animation
      float tvProgress = clamp(progress * 2.0 - 1.0, 0.0, 1.0);
      tvProgress = easeOutQuad(tvProgress);

      // Scale down the window vertically
      float scale = 1.0 / mix(1.0, SCALING, tvProgress) - 1.0;
      vec2 coords = coords_geo.xy;
      coords.y = coords.y * (scale + 1.0) - scale * 0.5;

      // Glitch
      float glitchProgress = easeInQuad(progress);
      float time = glitchProgress * U_DURATION * U_SPEED;
      float strength = U_STRENGTH * glitchProgress;
      float displace = 1000.0 * strength / size_geo.x;
      float yPos = U_SCALE * size_geo.y * (coords.y + uSeed * 10.0);

      // Create noise waves
      float noise = clamp(noise2D(vec2(time, yPos * 0.002)) - 0.5, 0.0, 1.0);
      noise += (noise2D(vec2(time * 10.0, yPos * 0.05)) - 0.5) * 0.15;

      // Apply X displacement
      float xPos = clamp(coords.x - displace * noise * noise, 0.0, 1.0);

      // RGB splitting
      float splitAmt = (glitchProgress * RGB_SEPARATION) + (0.1 * noise * displace);
      
      vec3 cr = niri_geo_to_tex * vec3(xPos + splitAmt, coords.y, 1.0);
      vec3 cg = niri_geo_to_tex * vec3(xPos,            coords.y, 1.0);
      vec3 cb = niri_geo_to_tex * vec3(xPos - splitAmt, coords.y, 1.0);

      float r = texture2D(niri_tex, cr.st).r;
      float g = texture2D(niri_tex, cg.st).g;
      float b = texture2D(niri_tex, cb.st).b;
      float a = texture2D(niri_tex, cg.st).a;
      vec4 oColor = vec4(r, g, b, a);

      // Scanlines
      float line = SCANLINE_VISIBILITY * progress;
      float lineSpread = sin(coords_geo.y * SCANLINE_DENSITY);
      float scanlines = 1.0 - line + line * lineSpread;
      oColor.rgb *= scanlines;

      // Interference
      float interference = hash12(vec2(yPos * time));
      float interferenceStrength = noise * min(strength, 1.0);
      oColor.rgb = mix(oColor.rgb, vec3(interference), a * interferenceStrength);

      // Noise grain
      float grain = noise2D(size_geo.xy * coords + vec2(time * 100.0));
      float grainStrength = 0.2 * min(strength, 1.0);
      oColor.rgb = mix(oColor.rgb, vec3(grain), a * grainStrength);

      // TV spark 
      vec2 uv = coords_geo.xy - vec2(0.5);
      uv.x *= (size_geo.x / size_geo.y);

      float beams = 0.002 / (abs(uv.x * uv.y) + 0.002);
      float radial = 0.05 / (length(uv) + 0.05);
      float starShape = (beams * 0.5) + radial;

      float flashCurve = pow(tvProgress, SPARK_DELAY_EXP);
      float spark = mix(1.0, max(1.0, starShape * SPARK_BRIGHTNESS), flashCurve);
      oColor.rgb *= spark;

      // TV squish masks
      float tbProg = smoothstep(0.0, 1.0, clamp(tvProgress / TB_TIME, 0.0, 1.0));
      float lrProg = smoothstep(0.0, 1.0, clamp((tvProgress - LR_DELAY) / LR_TIME, 0.0, 1.0));
      float ffProg = smoothstep(0.0, 1.0, clamp((tvProgress - 1.0 + FF_TIME) / FF_TIME, 0.0, 1.0));

      float tb = coords.y * 2.0; tb = tb < 1.0 ? tb : 2.0 - tb;
      float lr = coords.x * 2.0; lr = lr < 1.0 ? lr : 2.0 - lr;

      float tbMask = 1.0 - smoothstep(0.0, 1.0, clamp((tbProg - tb) / BLUR_WIDTH, 0.0, 1.0));
      float lrMask = 1.0 - smoothstep(0.0, 1.0, clamp((lrProg - lr) / BLUR_WIDTH, 0.0, 1.0));
      float ffMask = 1.0 - smoothstep(0.0, 1.0, ffProg);
      oColor.a *= tbMask * lrMask * ffMask;

      // Premultiply alpha (niri requires this)
      oColor.rgb *= oColor.a;

      return oColor;
    }

    vec4 open_color(vec3 coords_geo, vec3 size_geo) {
      return glitch(coords_geo, size_geo, 1.0 - niri_clamped_progress);
    }

    vec4 close_color(vec3 coords_geo, vec3 size_geo) {
      return glitch(coords_geo, size_geo, niri_clamped_progress);
    }
  '';
in
{
  programs.niri.settings = {
    animations =
      let
        windowAnim = {
          enable = true;
          kind.easing = {
            curve = "linear";
            inherit duration-ms;
          };
          custom-shader = glitchFrag;
        };
      in
      {
        window-open = windowAnim;
        window-close = windowAnim;
      };
  };
}
