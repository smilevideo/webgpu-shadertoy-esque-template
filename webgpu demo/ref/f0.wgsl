struct Uniforms {
  viewportResolution: vec2f,
  cursorPosition: vec2f,
  secondsElapsed: f32,
};

@group(0) @binding(0) var<uniform> uniforms: Uniforms;

@vertex fn vertex_shader(
  @builtin(vertex_index) VertexIndex: u32
) -> @builtin(position) vec4f {
  var vertices = array<vec2f, 3>(
    vec2f(-1.0, -1.0),
    vec2f(3.0, -1.0),
    vec2f(-1.0, 3.0)
  );

  return vec4f(vertices[VertexIndex], 0.0, 1.0);
}
