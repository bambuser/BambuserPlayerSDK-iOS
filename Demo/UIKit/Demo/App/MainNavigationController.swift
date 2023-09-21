import UIKit

class MainNavigationController: UINavigationController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        visibleViewController?.supportedInterfaceOrientations ??
            super.supportedInterfaceOrientations
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        visibleViewController?.preferredInterfaceOrientationForPresentation ??
            super.preferredInterfaceOrientationForPresentation
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

private extension MainNavigationController {
    func setupUI() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGroupedBackground
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear

        navigationBar.scrollEdgeAppearance = appearance
    }
}
