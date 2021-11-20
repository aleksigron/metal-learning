import Cocoa
import MetalKit

class ViewController: NSViewController
{
    var mtkView: MTKView!;
    var renderer: Renderer!;

    override func viewDidLoad()
    {
        super.viewDidLoad()

        mtkView = MTKView();

        let device = MTLCreateSystemDefaultDevice()!
        mtkView.device = device
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.frame = NSMakeRect(0, 0, 1280, 720);

        view.addSubview(mtkView);
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView!]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView!]))

        renderer = Renderer(view: mtkView, device: device);
        mtkView.delegate = renderer;
    }
}
