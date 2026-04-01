vec4 stable_crossfade(vec3 coords_curr_geo, vec3 size_curr_geo) {
  float ratio_x = niri_curr_geo_to_prev_geo[0][0] / niri_curr_geo_to_next_geo[0][0];
  float ratio_y = niri_curr_geo_to_prev_geo[1][1] / niri_curr_geo_to_next_geo[1][1];

  float is_growing_x = step(1.001, ratio_x);
  float is_growing_y = step(1.001, ratio_y);

  float is_changing_x = step(0.001, abs(ratio_x - 1.0));
  float is_changing_y = step(0.001, abs(ratio_y - 1.0));

  float overshoot = max(1.0, niri_progress); 
  vec2 progress_mult = vec2(
    mix(overshoot, 1.0 / overshoot, is_growing_x),
    mix(overshoot, 1.0 / overshoot, is_growing_y)
  );

  progress_mult.x = mix(1.0, progress_mult.x, is_changing_x);
  progress_mult.y = mix(1.0, progress_mult.y, is_changing_y);
  coords_curr_geo.xy *= progress_mult;

  vec3 p_prev = niri_curr_geo_to_prev_geo * coords_curr_geo;
  vec3 p_next = niri_curr_geo_to_next_geo * coords_curr_geo;
  vec3 t_prev = niri_geo_to_tex_prev * p_prev;
  vec3 t_next = niri_geo_to_tex_next * p_next; 

  vec4 color_prev = texture2D(niri_tex_prev, t_prev.st);
  vec4 color_next = texture2D(niri_tex_next, t_next.st);
  vec4 fade_color = mix(color_prev, color_next, niri_clamped_progress);
  vec4 final_color = fade_color;

  vec2 s_old = step(p_prev.xy, vec2(1.0));
  vec2 s_new = step(p_next.xy, vec2(1.0));

  vec4 fringe_y = mix(color_prev, color_next, is_growing_y);
  float out_y = mix(1.0 - s_new.y, 1.0 - s_old.y, is_growing_y); 
  final_color = mix(final_color, fringe_y, out_y);

  vec4 fringe_x = mix(color_prev, color_next, is_growing_x);
  float out_x = mix(1.0 - s_new.x, 1.0 - s_old.x, is_growing_x);
  final_color = mix(final_color, fringe_x, out_x);

  return final_color;
}

vec4 resize_color(vec3 coords_curr_geo, vec3 size_curr_geo) {
  return stable_crossfade(coords_curr_geo, size_curr_geo);
}