import SwiftUI
import UIKit

extension View {
    
    func interfaceOrientations(
        supported: UIInterfaceOrientationMask,
        preferred: UIInterfaceOrientation? = nil
    ) -> some View {
        self.background(
            OrientationView(
                supportedOrientations: supported,
                preferredOrientation: preferred
            )
        )
    }
}

private struct OrientationView: UIViewControllerRepresentable {
    
    var supportedOrientations: UIInterfaceOrientationMask
    var preferredOrientation: UIInterfaceOrientation?
    
    func updateUIViewController(_ uiViewController: OrientationViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> OrientationViewController {
        OrientationViewController(
            supportedOrientations: supportedOrientations,
            preferredOrientation: preferredOrientation
        )
    }
}

private class OrientationViewController: UIViewController {
    
    private var supportedOrientations: UIInterfaceOrientationMask
    private var preferredOrientation: UIInterfaceOrientation?
    
    init(
        supportedOrientations: UIInterfaceOrientationMask,
        preferredOrientation: UIInterfaceOrientation?
    ) {
        self.supportedOrientations = supportedOrientations
        self.preferredOrientation = preferredOrientation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        supportedOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        preferredOrientation ?? super.preferredInterfaceOrientationForPresentation
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 16.0, *) {
            self.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            let orientationValue = preferredInterfaceOrientationForPresentation.rawValue
            UIDevice.current.setValue(orientationValue, forKey: "orientation")
        }
    }
}
