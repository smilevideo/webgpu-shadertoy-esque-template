// use intense blue instead of red (not sure how >1 values work)

@fragment fn fragment_shader(
  @builtin(position) fragmentCoordinate : vec4f
) -> @location(0) vec4f {  
  var clipCoordinates = ((fragmentCoordinate.xy / uniforms.viewportResolution.xy) - 0.5) * 2.0;
  clipCoordinates = vec2f(clipCoordinates.x * (uniforms.viewportResolution.x / uniforms.viewportResolution.y), clipCoordinates.y);
  var d = length(clipCoordinates);

  var colors = vec3f(1.0, 2.0, 3.0);

  d = sin(8.0 * d + uniforms.secondsElapsed) / 8.0;
  d = abs(d);

  d = 0.01 / d;

  colors *= d;

  return vec4f(colors, 1.0);
}
