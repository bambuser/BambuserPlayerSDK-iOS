import SwiftUI

struct CustomWebView: UIViewControllerRepresentable {
    
    private var viewController: CustomWebViewController
    
    init(url: URL, isBeingPopped: @escaping () -> ()) {
        viewController = .init(url: url, isBeingPopped: isBeingPopped)
    }

    func makeUIViewController(context: Context) -> CustomWebViewController {
        viewController
    }
    
    func updateUIViewController(_ viewController: CustomWebViewController, context: Context) {}
    
    static func dismantleUIViewController(_ viewController: CustomWebViewController, coordinator: ()) {
        viewController.onClose()
    }
}
