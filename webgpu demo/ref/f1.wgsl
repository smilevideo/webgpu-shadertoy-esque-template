// left-right red gradient

@fragment fn fragment_shader(
  @builtin(position) fragmentCoordinate : vec4f
) -> @location(0) vec4f {  
  var coordinates = fragmentCoordinate.xy / uniforms.viewportResolution.xy;
  return vec4f(coordinates.x, 0.0, 0.0, 1.0);
}
