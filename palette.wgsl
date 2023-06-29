fn palette(t: f32) -> vec3f {
  var a = vec3f(0.5, 0.5, 0.5);
  var b = vec3f(0.5, 0.5, 0.5); 
  var c = vec3f(1.0, 1.0, 1.0);
  var d = vec3f(0.263, 0.416, 0.557);

  return a + b * cos(2 * 3.14159 * (c * t + d));
}
