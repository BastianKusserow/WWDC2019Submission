import CoreML
import Foundation
import UIKit
import Vision

public class NumberClassifier {
    private let dataSource: ImageDataSource
    weak var delegate: ClassificationResultDelegate?
    
    init(_ dataSource: ImageDataSource) {
        self.dataSource = dataSource
    }

    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MNIST().model)
            return VNCoreMLRequest(model: model, completionHandler: self.handleClassification)
        } catch {
            fatalError("VNCoreMLModel could not be created")
        }
    }()

    private func handleClassification(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNClassificationObservation] else { return }
        // We use the first two results from the classification so that the chance for ambigious images is higher
        let results = Array(observations[0...1]).map { Int($0.identifier)! }
        delegate?.didClassificationRequest(with: results)
    }

    public func predictNumber() {
        guard let image = self.dataSource.getImage() else { fatalError("Get image failed.") }
        
        guard let resultImage = UIImage(cgImage: image).resize(to: CGSize(width: 28, height: 28)) else { fatalError("Failed to resize cg image") }
        guard let cgImage = resultImage.cgImage else { fatalError("Failed to resize ci Image") }

        let ciImage = CIImage(cgImage: cgImage)
        let handler = VNImageRequestHandler(ciImage: ciImage)
        do {
            try handler.perform([self.classificationRequest])
        } catch {
            print(error)
        }
    }
}
