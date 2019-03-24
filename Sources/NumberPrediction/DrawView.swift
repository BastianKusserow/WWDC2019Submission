
import UIKit

class DrawView: UIView, ImageDataSource {
    
    private var linewidth = CGFloat(15) { didSet { setNeedsDisplay() } }
    private var color = UIColor.white { didSet { setNeedsDisplay() } }
    private var lines: [Line] = []
    private var lastPoint: CGPoint!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        lastPoint = touches.first!.location(in: self)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let newPoint = touches.first!.location(in: self)
        lines.append(Line(start: lastPoint, end: newPoint))
        lastPoint = newPoint
        
        setNeedsDisplay()
    }
    
    func clear() {
        lines = []
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let drawPath = UIBezierPath()
        drawPath.lineCapStyle = .round

        for line in lines{
            drawPath.move(to: line.start)
            drawPath.addLine(to: line.end)
        }
        
        drawPath.lineWidth = linewidth
        color.set()
        drawPath.stroke()
    }
    
    func getImage() -> CGImage? {
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.none.rawValue
        let context = CGContext(data: nil, width: 28, height: 28, bitsPerComponent: 8, bytesPerRow: 28, space: colorSpace, bitmapInfo: bitmapInfo)
        
        // scale image to 28 x 28
        context?.translateBy(x: 0 , y: 28)
        context?.scaleBy(x: 28/self.frame.size.width, y: -28/self.frame.size.height)
        self.layer.render(in: context!)
        context?.setFillColor(UIColor.black.cgColor)
        return context?.makeImage()
    }
}
