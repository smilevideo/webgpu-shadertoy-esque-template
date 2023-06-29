// increase saturation of red according to distance from center

@fragment fn fragment_shader(
  @builtin(position) fragmentCoordinate : vec4f
) -> @location(0) vec4f {  
  var clipCoordinates = ((fragmentCoordinate.xy / uniforms.viewportResolution.xy) - 0.5) * 2.0;
  var d = length(clipCoordinates);
  return vec4f(d, 0.0, 0.0, 1.0);
}
