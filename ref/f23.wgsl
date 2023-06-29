// slow down palette index increase

@fragment fn fragment_shader(
  @builtin(position) fragmentCoordinate : vec4f
) -> @location(0) vec4f {  
  var finalColor = vec3f(0.0);

  var clipCoordinates = ((fragmentCoordinate.xy / uniforms.viewportResolution.xy) - 0.5) * 2.0;
  clipCoordinates = vec2f(clipCoordinates.x * (uniforms.viewportResolution.x / uniforms.viewportResolution.y), clipCoordinates.y);

  var d0 = length(clipCoordinates);

  var fractCoordinates = clipCoordinates;

  for (var i = 0; i < 2; i++) {
    fractCoordinates = (fract(fractCoordinates) - 0.5) * 2.0;

    var d = length(fractCoordinates);

    var colors = palette(d0 + uniforms.secondsElapsed * 0.5);

    d = sin(8.0 * d + uniforms.secondsElapsed) / 8.0;
    d = abs(d);

    d = 0.01 / d;

    finalColor += colors * d;
  }

  return vec4f(finalColor, 1.0);
}
