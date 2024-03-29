//
//  PlayerMenu.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import SwiftUI
import BambuserPlayerSDK

/**
 This is a demo-specific menu, that can be used to control a
 demo-specific player. Only use it for inspiration.
 */
struct PlayerMenu: View {
    @Binding var isPipActive: Bool
    @Binding var isShowPlaying: Bool

    let showCloseButton: Bool
    
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject private var settings: DemoSettings
    
    var body: some View {
        HStack {
            button(isShowPlayingImage, action: toggleShowIsPlaying)
            if settings.isPiPEnabled {
                button(pipImage, action: togglePip)
            }
            if showCloseButton {
                button(.close, action: dismiss)
            }
        }
    }
}


// MARK: - Modifiers

extension PlayerMenu {
    
    /**
     Using this modifier embeds the menu in a dark container
     view that is intended to "float" above the player.
     */
    func asOverlay() -> some View {
        self.accentColor(.white)
            .padding(5)
            .font(.title2.weight(.regular))
            .background(Color.black)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.4), radius: 4, x: 0, y: 3)
    }
}


// MARK: - Private logic

private extension PlayerMenu {
    
    var isPipEnabled: Bool {
        isPipActive
    }
    
    var pipImage: Image {
        isPipEnabled ? .pipExit : .pipEnter
    }

    var isShowPlayingImage: Image {
        isShowPlaying ? .pause : .play
    }
    
    func button(_ image: Image, action: @escaping () -> Void) -> some View {
        Button(action: action) { image }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func togglePip() {
        withAnimation {
            isPipActive.toggle()
        }
    }

    func toggleShowIsPlaying() {
        withAnimation {
            settings.playerContext.sendEvent(isShowPlaying ? .pause : .resume)
            isShowPlaying.toggle()
        }
    }
}

struct PlayerMenu_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayerMenu(
            isPipActive: .constant(false),
            isShowPlaying: .constant(true),
            showCloseButton: true)
            .environmentObject(DemoSettings())
    }
}
