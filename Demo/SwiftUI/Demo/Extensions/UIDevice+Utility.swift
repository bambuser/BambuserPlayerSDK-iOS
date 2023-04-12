import UIKit

extension UIDevice {
    
    func isPad() -> Bool {
        userInterfaceIdiom == .pad
    }
}
