import UIKit

extension UIView {
    
    func pinHorizontal(to view: UIView?) {
        guard let view = view else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerYAnchor.constraint(equalTo: view.centerYAnchor),
            widthAnchor.constraint(equalToConstant: view.frame.width),
            heightAnchor.constraint(equalTo: widthAnchor)
            ])
    }
}

