import MetalKit

let vertexData:[Float] = [
    0.0, 0.5, 0.0,
    -0.25, 0.0, 0.0,
    0.25, 0.0, 0.0,
    0.25, 0.0, 0.0,
    -0.25, 0.0, 0.0,
    0.0, -0.5, 0.0]

class Renderer: NSObject, MTKViewDelegate
{
    private var mtkView: MTKView!;
    private var device: MTLDevice!;

    private var queue: MTLCommandQueue! = nil;
    private var vertexBuffer: MTLBuffer! = nil;
    private var pipelineState: MTLRenderPipelineState! = nil;

    init(view: MTKView, device: MTLDevice)
    {
        super.init();

        self.mtkView = view;
        self.device = device;

        queue = device.makeCommandQueue();

        // Create vertex buffer

        let dataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0]);
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: dataSize);

        // Load shaders

        let defaultLibrary = device.makeDefaultLibrary();
        let fragmentProgram = defaultLibrary!.makeFunction(name: "basic_fragment");
        let vertexProgram = defaultLibrary!.makeFunction(name: "basic_vertex");

        // Create render pipeline

        let pipelineDescriptor = MTLRenderPipelineDescriptor();
        pipelineDescriptor.vertexFunction = vertexProgram;
        pipelineDescriptor.fragmentFunction = fragmentProgram;
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat;

        do
        {
            try pipelineState = device.makeRenderPipelineState(
                descriptor: pipelineDescriptor);
        }
        catch let error
        {
            print("Failed to create pipeline state, error \(error)");
        }
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize)
    {
    }

    func draw(in view: MTKView)
    {
        let commandBuffer = queue.makeCommandBuffer()!;

        if let passDescriptor = view.currentRenderPassDescriptor,
           let drawable = view.currentDrawable
        {
            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: passDescriptor)!;

            encoder.setRenderPipelineState(pipelineState);
            encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0);
            encoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6);
            encoder.endEncoding();

            commandBuffer.present(drawable);
            commandBuffer.commit();
        }
    }
}
