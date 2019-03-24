import Foundation

protocol ClassificationResultDelegate: class {
    func didClassificationRequest(with results: [Int])
}
