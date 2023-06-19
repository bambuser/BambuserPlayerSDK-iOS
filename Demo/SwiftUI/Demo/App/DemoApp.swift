//
//  DemoApp.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import SwiftUI
import BambuserPlayerSDK

@main
struct DemoApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var settings = DemoSettings()
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(settings)
                .onChange(of: scenePhase) { newPhase in
                    guard newPhase == .active else { return }

                    let shouldRestorePip = settings.shouldRestorePiPAutomatically
                    let pipIsActive = PictureInPictureState.shared.isPictureInPictureActive

                    if shouldRestorePip && pipIsActive {
                        PictureInPictureState.shared.restorePlayer()
                    }
                }
        }
    }
}
