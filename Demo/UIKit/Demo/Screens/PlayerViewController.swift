//
//  PlayerViewController.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import BambuserPlayerSDK
import UIKit
import WebKit
import SwiftUI

/**
 This screen is responsible for creating a player view, with
 support for both push, sheet and full modal navigation.
 
 The player listens for player events, using a shared player
 configuration that is provided by `DemoPlayerSettings`. The
 screen implements `DemoPlayerEventHandler` to handle events,
 like saving calendar events, sharing events etc.
 */
class PlayerViewController: BambuserPlayerViewController, DemoPlayerEventHandler {
    
    private let tracking = BambuserConversionTracking()
    
    // MARK: - Initialization
    
    init(settings: DemoSettings) {
        self.settings = settings
        var eventHandler: ((BambuserPlayerEvent) -> Void)?
        super.init(
            showId: settings.showId,
            environment: settings.environment,
            config: settings.playerConfiguration,
            context: settings.playerContext,
            handlePlayerEvent: { event in
                eventHandler?(event)
            }
        )
        eventHandler = { [weak self] event in
            self?.handlePlayerEvent(event)
        }
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) { nil }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .all
        }
        return [.portrait, .portraitUpsideDown]
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .portrait
        }
        return super.preferredInterfaceOrientationForPresentation
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupConstraints()

        playButton.setImage(.pause, for: .normal)
        playButton.addTarget(self, action: #selector(onTappedPlayButton), for: .touchUpInside)
        pipButton.setImage(pictureInPictureIsActive ? .pipExit : .pipEnter, for: .normal)
        pipButton.addTarget(self, action: #selector(onTappedPipButton), for: .touchUpInside)
        closeButton.setImage(.close, for: .normal)
        closeButton.addTarget(self, action: #selector(onTappedCloseButton), for: .touchUpInside)
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParent || isBeingDismissed {
            settings.loadNextShow()
            onViewDidDisappear?()
        }
    }
    
    
    // MARK: - Properties
    
    var onViewDidDisappear: (() -> Void)?
    
    private var settings: DemoSettings
    private var pictureInPictureIsActive = false
    private var showIsPlaying = true { didSet {
        playButton.setImage(showIsPlaying ? .pause : .play, for: .normal)
    }}
    
    private var stackView: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()

    private let playButton = UIButton()
    private var closeButton = UIButton()
    private let pipButton = UIButton()
}


// MARK: - Actions

@objc private extension PlayerViewController {

    func onTappedPlayButton() {
        settings.playerContext.sendEvent(showIsPlaying ? .pause : .resume)
        showIsPlaying.toggle()
    }
    
    func onTappedPipButton() {
        settings.playerContext.sendEvent(.togglePiP)
    }
    
    func onTappedCloseButton() {
        if navigationController == nil {
            if let presentedViewController {
                presentedViewController.dismiss(animated: true)
            }
            dismiss(animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
}


// MARK: - Internal Functionality

extension PlayerViewController {
    
    func dismiss() {
        onTappedCloseButton()
    }
    
    func saveCalendarEvent(in event: CalendarEvent) {
        event.saveToCalendar { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure: UIAlertController.show(
                title: "Error",
                message: "Failed to save calendar event.",
                from: self)
            case .success: UIAlertController.show(
                title: "Success",
                message: "Event was added to calendar at \(event.startDate).",
                from: self)
            }
        }
    }

    func shareUrl(url: URL) {
        print("Show share sheet for url: \(url)")
        LiveShoppingShareHelper.share(
            url: url,
            on: self
        )
    }

    func openExternalUrl(_ url: URL?) {
        guard let url = url else {
            UIAlertController.show(
                title: "Error",
                message: "Invalid url while opening external link",
                from: self)

            return
        }

        UIApplication.shared.open(url)
    }

    func openProductDetails(_ product: BambuserPlayerEvent.Product) {
        guard let url = product.publicUrl else {
            return
        }
        
        // create a new event to track purchases
        // replace the values with your data
        let event = PurchaseTrackingEvent(
            orderId: "123", // the order id
            orderValue: 12345.0, // total of all products in the order
            orderProductIds: [product.id], // array of all product ids in the order
            currency: "USD" // the currency used for the order (ISO 4217)
        )
        tracking.collect(event)

        let webController = CustomWebViewController(url: url) { [ weak self] in
            if self?.settings.isPiPEnabled == true {
                self?.settings.playerContext.sendEvent(.exitPiP)
            }
        }

        if settings.isPiPEnabled {
            settings.playerContext.sendEvent(.enterPiP)
        }

        if let navigationController {
            navigationController.pushViewController(webController, animated: true)
        } else {
            present(webController, animated: true)
        }
    }

    func handlePiPStateChange(action: PlayerPipAction) {
        pictureInPictureIsActive = action == .open

        pipButton.setImage(pictureInPictureIsActive ? .pipExit : .pipEnter, for: .normal)

        switch action {
        case .open: break
        case .close:
            dismiss()
        case .restore:
            if let navigationController, navigationController.visibleViewController != self {
                navigationController.popToViewController(self, animated: true)
            } else if presentedViewController != nil {
                dismiss(animated: true)
            }
        }
    }
    
    func handlePlayerError(_ error: BambuserPlayerSDKError) {
        switch error {
        case .showInitialization:
            handleShowError(nil, closePlayerOnAction: true)
        case .playerInitialization(let error):
            handleShowError(error, closePlayerOnAction: true)
        case .unknown(let error):
            handleShowError(error)
        }
    }
    
    func handleShowError(_ error: Error?, closePlayerOnAction: Bool = false) {
        UIAlertController.show(
            title: "Error",
            message: error?.localizedDescription ??
            "Can't start the show. Please check your 'Show Id'.",
            from: self,
            with: { [weak self] _ in
                if closePlayerOnAction {
                    self?.dismiss()
                }
            }
        )
    }
}


// MARK: - Private Functionality

private extension PlayerViewController {
    func handlePlayerEvent(_ event: BambuserPlayerEvent) {
        switch event {
        case .playerFailed(let error): handlePlayerError(error)
        case .openTosOrPpUrl(let url): openExternalUrl(url)
        case .openUrlFromChat(let url): openExternalUrl(url)
        case .openProduct(let product): openProductDetails(product)
        case .openShareShowSheet(let url): shareUrl(url: url)
        case .close: dismiss()
        case .pictureInPictureStateChanged(action: let action):
            handlePiPStateChange(action: action)
        case .openCalendar(let info): saveCalendarEvent(in: info)
        case .productWasHighlighted(let product):
            print("Product was highlighted: \(product.title ?? "untitled product")")
        case .playButtonTapped: showIsPlaying = true
        case .pauseButtonTapped: showIsPlaying = false
        default: print("Unhandled Event: \(event)")
        }
    }
}


// MARK: - Private View Setup

private extension PlayerViewController {
    
    func setupViews() {
        stackView.addArrangedSubview(playButton)
        stackView.addArrangedSubview(closeButton)
        stackView.addArrangedSubview(pipButton)

        view.addSubview(stackView)
    }
    
    func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 50),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
