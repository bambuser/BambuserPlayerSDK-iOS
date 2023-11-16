//
//  DemoSettings.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import BambuserPlayerSDK
import Combine
import SwiftUI

/**
 This is a demo-specific class that can be used to configure
 the demo app and handle its state.
 */
class DemoSettings: ObservableObject {
    
    init() {
        if let configuration = PlayerConfiguration.storedObject {
            playerConfiguration = configuration
            setupFields(with: configuration)
        } else {
            playerConfiguration = PlayerConfiguration.standard()
        }

        addListeners()
    }
    
    // MARK: - Localization

    @Published var preferredLocale: Locale? = .default

    // MARK: - Shows
    
    @Published var showId: String = "vAtJH3xevpYTLnf1oHao"
    @Published var environment: BambuserEnvironment?
    @Published var automaticallyLoadNextShow = false
    @Published var upcomingShows: [String] = [
        "evsxrTCdPZeLIvywqA3C",
        "A9WtDJUip6LNNdpsarwi"
    ]
    
    // MARK: - Configuration

    @Published private(set) var playerConfiguration: PlayerConfiguration
    var playerContext = BambuserPlayerContext()
    
    // MARK: - Settings
    
    @Published var isPiPAutomatic = true
    @Published var isPiPEnabled = true
    @Published var hideUiOnPip = true
    @AppStorage("shouldRestorePiPAutomatically") var shouldRestorePiPAutomatically = true

    @Published var allUI = true
    @Published var showNumberOfViewers = true
    @Published var chatOverlay = true
    @Published var emojiOverlay = true
    @Published var productList = true
    @Published var productListLayout: PlayerUIConfiguration.HighlightedProductsLayout = .modern
    @Published var productListLayoutDate = Date()
    @Published var actionBar = true
    @Published var emojiButton = true
    @Published var cartButton = true
    @Published var chatVisibilityButton = true
    @Published var chatInputField = true
    @Published var shareButton = true
    @Published var productsOnCurtain = true
    @Published var showPDPOnProductTap = true
    @Published var productPlayButton = true

    // MARK: - Cancellables

    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Functions
    
    /**
     Load the "next" show, which in the demo toggles between
     the `firstShowId` and `secondShowId`
     */
    func loadNextShow() {
        guard !upcomingShows.isEmpty, automaticallyLoadNextShow else { return }
        if upcomingShows.first == showId, !upcomingShows.isEmpty {
            upcomingShows.removeFirst()
        }

        showId = upcomingShows.first ?? showId
        if !upcomingShows.isEmpty {
            upcomingShows.removeFirst()
        }
    }
}

private extension DemoSettings {
    
    /**
     Setup settings fields with `PlayerConfiguration`.
     */
    func setupFields(with configuration: PlayerConfiguration) {
        preferredLocale = configuration.preferredLocale
        isPiPAutomatic = configuration.pipConfig.isAutomatic
        isPiPEnabled = configuration.pipConfig.isEnabled
        hideUiOnPip = configuration.pipConfig.hideUiOnPip
        allUI = configuration.uiConfig.allUI == .visible
        showNumberOfViewers = configuration.uiConfig.showNumberOfViewers == .visible
        chatOverlay = configuration.uiConfig.chatOverlay == .visible
        emojiOverlay = configuration.uiConfig.emojiOverlay == .visible
        productList = configuration.uiConfig.productList == .visible
        productListLayout = configuration.uiConfig.productListLayout
        actionBar = configuration.uiConfig.actionBar == .visible
        emojiButton = configuration.uiConfig.emojiButton == .visible
        cartButton = configuration.uiConfig.cartButton == .visible
        chatVisibilityButton = configuration.uiConfig.chatVisibilityButton == .visible
        chatInputField = configuration.uiConfig.chatInputField == .visible
        shareButton = configuration.uiConfig.shareButton == .visible
        productsOnCurtain = configuration.uiConfig.productsOnEndCurtain == .visible
        showPDPOnProductTap = configuration.uiConfig.showPDPOnProductTap
        productPlayButton = configuration.uiConfig.productPlayButton == .visible
    }
    
    /**
     Add listeres of fields changes to sync the data with `PlayerConfiguration`.
     */
    func addListeners() {
        addListener(value: $preferredLocale, at: \.preferredLocale)
        addListener(value: $isPiPAutomatic, at: \.pipConfig.isAutomatic)
        addListener(value: $isPiPEnabled, at: \.pipConfig.isEnabled)
        addListener(value: $hideUiOnPip, at: \.pipConfig.hideUiOnPip)
        addListener(value: $allUI, at: \.uiConfig.allUI)
        addListener(value: $showNumberOfViewers, at: \.uiConfig.showNumberOfViewers)
        addListener(value: $chatOverlay, at: \.uiConfig.chatOverlay)
        addListener(value: $emojiOverlay, at: \.uiConfig.emojiOverlay)
        addListener(value: $productList, at: \.uiConfig.productList)
        addListener(value: $productListLayout, at: \.uiConfig.productListLayout)
        addListener(value: $actionBar, at: \.uiConfig.actionBar)
        addListener(value: $emojiButton, at: \.uiConfig.emojiButton)
        addListener(value: $cartButton, at: \.uiConfig.cartButton)
        addListener(value: $chatVisibilityButton, at: \.uiConfig.chatVisibilityButton)
        addListener(value: $chatInputField, at: \.uiConfig.chatInputField)
        addListener(value: $shareButton, at: \.uiConfig.shareButton)
        addListener(value: $productsOnCurtain, at: \.uiConfig.productsOnEndCurtain)
        addListener(value: $showPDPOnProductTap, at: \.uiConfig.showPDPOnProductTap)
        addListener(value: $productPlayButton, at: \.uiConfig.productPlayButton)
    }

    /**
     Start listening to published value
     */
    private func addListener<P, C>(
        value: Published<P>.Publisher,
        at keypath: ReferenceWritableKeyPath<PlayerConfiguration, C>
    ) {
        value.sink { [weak self] value in
            if P.self == C.self {
                if let value = value as? C {
                    // If keypath type is equal to the published value type
                    // (Bool, Locale)
                    self?.playerConfiguration[keyPath: keypath] = value
                }
            } else {
                if let value = value as? Bool,
                   let uiState = value.uiState as? C {
                    // If keypath type is PlayerOverlayVisibility
                    self?.playerConfiguration[keyPath: keypath] = uiState
                }
            }

            self?.playerConfiguration.saveObject()
        }
        .store(in: &cancellables)
    }
}

private extension Bool {
    
    /**
     Get a `UIState` for the current bool value.
     */
    var uiState: PlayerOverlayVisiblity {
        self ? .visible : .hidden
    }
}

private extension Decodable {
    
    /**
     Get stored object in UserDefaults by key.
     Class Name is a key.
     */
    static var storedObject: Self? {
        guard let data = UserDefaults.standard.data(forKey: String(describing: Self.self)),
              let decoded = try? JSONDecoder().decode(Self.self, from: data)
        else { return nil }
        return decoded
    }
}

private extension Encodable {
    
    /**
     Save current object to UserDefaults.
     Class Name is a key.
     */
    func saveObject() {
        guard let encoded = try? JSONEncoder().encode(self)
        else { return }
        UserDefaults.standard.set(encoded, forKey: String(describing: Self.self))
    }
}

extension Locale {
    
    /**
     Default predefined locale:
     English (United States).
     */
    static var `default`: Locale {
        return Locale(identifier: "en-US")
    }
}
