// use the distance to the canvas center as well

@fragment fn fragment_shader(
  @builtin(position) fragmentCoordinate : vec4f
) -> @location(0) vec4f {  
  var clipCoordinates = ((fragmentCoordinate.xy / uniforms.viewportResolution.xy) - 0.5) * 2.0;
  clipCoordinates = vec2f(clipCoordinates.x * (uniforms.viewportResolution.x / uniforms.viewportResolution.y), clipCoordinates.y);

  var d0 = length(clipCoordinates);

  var fractCoordinates = (fract(clipCoordinates) - 0.5) * 2.0;

  var d = length(fractCoordinates);

  var colors = palette(d0 + uniforms.secondsElapsed);

  d = sin(8.0 * d + uniforms.secondsElapsed) / 8.0;
  d = abs(d);

  d = 0.01 / d;

  colors *= d;

  return vec4f(colors, 1.0);
}
