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
    
    
    // MARK: - Shows
    
    @Published var showId: String = "vAtJH3xevpYTLnf1oHao"
    @Published var environment: BambuserEnvironment?
    @Published var automaticallyLoadNextShow = false
    @Published var upcomingShows: [String] = [
        "xB4a9LpDq5mU0CdCZa3k",
        "64HtFC21MpBGEx6RSynn"
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
    @Published var chatOverlay = true
    @Published var emojiOverlay = true
    @Published var productList = true
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
        isPiPAutomatic = configuration.pipConfig.isAutomatic
        isPiPEnabled = configuration.pipConfig.isEnabled
        hideUiOnPip = configuration.pipConfig.hideUiOnPip
        allUI = configuration.uiConfig.allUI == .visible
        chatOverlay = configuration.uiConfig.chatOverlay == .visible
        emojiOverlay = configuration.uiConfig.emojiOverlay == .visible
        productList = configuration.uiConfig.productList == .visible
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
        addListener(value: $isPiPAutomatic, at: \.pipConfig.isAutomatic)
        addListener(value: $isPiPEnabled, at: \.pipConfig.isEnabled)
        addListener(value: $hideUiOnPip, at: \.pipConfig.hideUiOnPip)
        addListener(value: $allUI, at: \.uiConfig.allUI)
        addListener(value: $chatOverlay, at: \.uiConfig.chatOverlay)
        addListener(value: $emojiOverlay, at: \.uiConfig.emojiOverlay)
        addListener(value: $productList, at: \.uiConfig.productList)
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
    private func addListener<T>(
        value: Published<Bool>.Publisher,
        at keypath: ReferenceWritableKeyPath<PlayerConfiguration, T>
    ) {
        value.sink { [weak self] value in
            if let boolValue = value as? T {
                // If keypath type is Bool
                self?.playerConfiguration[keyPath: keypath] = boolValue
            } else if let uiState = value.uiState as? T {
                // If keypath type is PlayerOverlayVisibility
                self?.playerConfiguration[keyPath: keypath] = uiState
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
