const shaderCode = `
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

fn palette(t: f32) -> vec3f {
  var a = vec3f(0.5, 0.5, 0.5);
  var b = vec3f(0.5, 0.5, 0.5); 
  var c = vec3f(1.0, 1.0, 1.0);
  var d = vec3f(0.263, 0.416, 0.557);

  return a + b * cos(2 * 3.14159 * (c * t + d));
}


// left-right red gradient

@fragment fn fragment_shader(
  @builtin(position) fragmentCoordinate : vec4f
) -> @location(0) vec4f {  
  var finalColor = vec3f(0.0);

  var clipCoordinates = ((fragmentCoordinate.xy / uniforms.viewportResolution.xy) - 0.5) * 2.0;
  clipCoordinates = vec2f(clipCoordinates.x * (uniforms.viewportResolution.x / uniforms.viewportResolution.y), clipCoordinates.y);

  var d0 = length(clipCoordinates);

  var fractCoordinates = clipCoordinates;

  for (var i = 0; i < 4; i++) {
    fractCoordinates = (fract(fractCoordinates) - 0.5) * 1.5;

    var d = length(fractCoordinates);

    var colors = palette(d0 + f32(i) * 0.4 +uniforms.secondsElapsed * 0.5);

    d = sin(8.0 * d + uniforms.secondsElapsed) / 8.0;
    d = abs(d);

    d = 0.01 / d;

    finalColor += colors * d;
  }

  return vec4f(finalColor, 1.0);
}

`;

const init = async () => {
  const adapter = await navigator.gpu?.requestAdapter();
  const device = await adapter?.requestDevice();
  if (!device) {
    alert("WebGPU is not available on this browser.");
    return;
  }

  const canvas = document.querySelector("canvas");
  const context = canvas.getContext("webgpu");
  const presentationFormat = navigator.gpu.getPreferredCanvasFormat();
  context.configure({
    device,
    format: presentationFormat,
  });

  const uniformBufferSize = 24;
  const uniformBuffer = device.createBuffer({
    size: uniformBufferSize,
    usage: GPUBufferUsage.UNIFORM | GPUBufferUsage.COPY_DST,
  });
  const uniformArrayBuffer = new ArrayBuffer(uniformBufferSize);

  const viewportResolution = new Float32Array(uniformArrayBuffer, 0, 2);
  const cursorPosition = new Float32Array(uniformArrayBuffer, 8, 2);
  const secondsElapsed = new Float32Array(uniformArrayBuffer, 16, 1);

  const module = device.createShaderModule({ code: shaderCode });
  const pipeline = device.createRenderPipeline({
    layout: "auto",
    vertex: {
      module,
      entryPoint: "vertex_shader",
    },
    fragment: {
      module,
      entryPoint: "fragment_shader",
      targets: [{ format: presentationFormat }],
    },
  });

  const bindGroup = device.createBindGroup({
    layout: pipeline.getBindGroupLayout(0),
    entries: [{ binding: 0, resource: { buffer: uniformBuffer } }],
  });

  function render(timestamp) {
    const width = canvas.clientWidth;
    const height = canvas.clientHeight;
    canvas.width = width;
    canvas.height = height;

    viewportResolution[0] = width;
    viewportResolution[1] = height;
    secondsElapsed[0] = timestamp * 0.001;
    device.queue.writeBuffer(uniformBuffer, 0, uniformArrayBuffer);

    const encoder = device.createCommandEncoder();
    const pass = encoder.beginRenderPass({
      colorAttachments: [
        {
          view: context.getCurrentTexture().createView(),
          clearColor: [0, 0, 0, 0],
          loadOp: "clear",
          storeOp: "store",
        },
      ],
    });
    pass.setPipeline(pipeline);
    pass.setBindGroup(0, bindGroup);
    pass.draw(3);
    pass.end();

    device.queue.submit([encoder.finish()]);
    requestAnimationFrame(render);
  }
  requestAnimationFrame(render);

  canvas.addEventListener("mousemove", (e) => {
    cursorPosition[0] = e.offsetX;
    cursorPosition[1] = e.offsetY;
  });
};

init();
