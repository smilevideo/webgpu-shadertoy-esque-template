// replace smoothstep with an inverse function to allow more color expression

@fragment fn fragment_shader(
  @builtin(position) fragmentCoordinate : vec4f
) -> @location(0) vec4f {  
  var clipCoordinates = ((fragmentCoordinate.xy / uniforms.viewportResolution.xy) - 0.5) * 2.0;
  clipCoordinates = vec2f(clipCoordinates.x * (uniforms.viewportResolution.x / uniforms.viewportResolution.y), clipCoordinates.y);
  var d = length(clipCoordinates);

  d = sin(8.0 * d + uniforms.secondsElapsed) / 8.0;
  d = abs(d);

  d = 0.01 / d;

  return vec4f(d, d, d, 1.0);
}
