//
//  CustomWebViewController.swift
//  Demo
//
//  Created by Pontus Jacobsson on 2023-03-15.
//  Copyright © 2023 Bambuser AB. All rights reserved.
//

import UIKit
import WebKit

class CustomWebViewController: UIViewController {
    var url: URL
    var isBeingPopped: () -> ()

    private var webView: WKWebView

    /// Initilize with the url that should be loaded on controller
    init(url: URL, isBeingPopped: @escaping () -> ()) {
        self.url = url
        self.isBeingPopped = isBeingPopped
        webView = .init(frame: .zero)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        super.viewDidLoad()

        view = webView

        webView.load(URLRequest(url: url))
    }

    override func viewDidDisappear(_ animated: Bool) {
        if isMovingFromParent || isBeingDismissed  {
            onClose()
        }

        super.viewDidDisappear(animated)
    }
    
    func onClose() {
        isBeingPopped()
    }
}
