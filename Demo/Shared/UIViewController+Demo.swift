//
//  UIViewController+Demo.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import UIKit

extension UIAlertController {

    class func show(title: String, message: String,
                    from controller: UIViewController, with handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        controller.present(alert, animated: true, completion: nil)
    }
}
