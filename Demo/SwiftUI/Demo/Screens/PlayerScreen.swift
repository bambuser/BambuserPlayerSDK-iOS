//
//  PlayerScreen.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import SwiftUI
import BambuserPlayerSDK

/**
 This screen is responsible for creating a player view, with
 support for both push, sheet and full modal navigation. The
 screen overlays the player with a demo-specific player menu.
 */
struct PlayerScreen: View {
    @State private var showCart = false

    init(
        showCloseButton: Bool,
        openPdpInNavigationStack: Bool
    ) {
        self.showCloseButton = showCloseButton
        self.openPdpInNavigationStack = openPdpInNavigationStack
    }
    
    let showCloseButton: Bool
    let openPdpInNavigationStack: Bool
    
    @StateObject private var alert = AlertContext()
    @StateObject private var sheet = SheetContext()
    @State private var tracking: BambuserConversionTracking?
    
    @State var isPipActive = false
    @State var isShowPlaying = true
    
    @EnvironmentObject private var settings: DemoSettings
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var isPdpOpened = false
    @State private var pdpUrl: URL?
    
    var body: some View {
        VStack(spacing: 5) {
            player
            menu
        }
        .sheet(context: sheet)
        .alert(context: alert)
        .overlay(pdpOverlay)
        .padding(5)
        .navigationBarTitleDisplayMode(.inline)
        .interfaceOrientations(
            supported: UIDevice.current.isPad() ? .all : [.portrait, .portraitUpsideDown],
            preferred: UIDevice.current.isPad() ? nil : .portrait
        )
        .onAppear {
            tracking = BambuserConversionTracking()
            if !UIDevice.current.isPad() {
                AppDelegate.orientationLock = .portrait
            }
        }
        .onDisappear {
            AppDelegate.orientationLock = .all
            settings.loadNextShow()
        }
        .sheet(isPresented: $showCart) {
            CartView()
        }
    }
    
    var pdpOverlay: some View {
        NavigationLink(
            isActive: $isPdpOpened,
            destination: {
                Group {
                    if let pdpUrl {
                        CustomWebView(url: pdpUrl) {
                            self.pdpUrl = nil
                            self.onPdpClosed()
                        }
                    }
                }
            },
            label: { EmptyView() }
        )
    }
}


// MARK: - View logic

private extension PlayerScreen {
    
    struct CartView: View {
        var body: some View {
            VStack {
                Spacer()
                Text("Cart View")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
        }
    }

    var menu: some View {
        PlayerMenu(
            isPipActive: .init(
                get: { isPipActive },
                set: { _ in settings.playerContext.sendEvent(.togglePiP) }),
            isShowPlaying: $isShowPlaying,
            showCloseButton: showCloseButton)
            .asOverlay()
            .padding(5)
            .environmentObject(settings)
    }
    
    var player: some View {
        playerView
            .background(BambuserLogoBackground())
            .cornerRadius(7)
            .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 2)
    }
    
    var playerView: some View {
        BambuserPlayerView(
            showId: settings.showId,
            environment: settings.environment,
            config: settings.playerConfiguration,
            context: settings.playerContext, 
            playerProductDataSource: settings.cartService,
            playerCartDataSource: settings.cartService,
            playerCartDelegate: settings.cartService,
            handlePlayerEvent: handlePlayerEvent
        )
    }
}


// MARK: - Internal Functionality

extension PlayerScreen {

    func handlePlayerEvent(event: BambuserPlayerEvent) {
        switch event {
        case let .playerFailed(error): handlePlayerError(error)
        case let .openTosOrPpUrl(url): openExternalUrl(url)
        case let .openUrlFromChat(url): openExternalUrl(url)
        case let .openShareShowSheet(url): openShareSheet(url)
        case .close: dismiss()
        case let .pictureInPictureStateChanged(action): handlePipStateChanged(action)
        case let .openCalendar(info): saveCalendarEvent(in: info)
        case .playButtonTapped: isShowPlaying = true
        case .pauseButtonTapped: isShowPlaying = false
        case .openCart:
            // Only triggers if `usePlayerCartView` == true
            // Check `PlayerUIConfiguration` for more info
            showCart = true
        case let .openProduct(product):
            // Only triggers if `usePlayerProductView` == true
            // Check `PlayerUIConfiguration` for more info
            openProductDetails(product)
        case let .productAddedToCart(product):
            print("Product added to cart - \(product)")
        default: print("Unhandled event: \(event)")
        }
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }

    func handlePipStateChanged(_ action: PlayerPipAction) {
        isPipActive = action == .open

        switch action {
        case .restore:
            isPdpOpened = false
            sheet.dismiss()
        case .close:
            isPdpOpened = false
            sheet.dismiss()
        default: break
        }
    }

    func openExternalUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }

    func openShareSheet(_ url: URL) {
        if #available(iOS 16.0, *) {
            sheet.present(
                ShareSheet(activityItems: [url])
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.hidden)
            )
        } else {
            sheet.present(
                ShareSheet(activityItems: [url])
            )
        }
    }

    func saveCalendarEvent(in event: CalendarEvent) {
        Task {
            do {
                try await event.save()
                let date = await event.startDate
                
                let successAlert = Alert(
                    title: Text("Success"),
                    message: Text("Event was added to calendar at \(date).")
                )
                alert.present(successAlert)
            } catch {
                let errorAlert = Alert(
                    title: Text("Error"),
                    message: Text(error.localizedDescription)
                )
                alert.present(errorAlert)
            }
        }
    }
        
    func openProductDetails(_ product: ProductProtocol) {
        guard let url = product.base?.url else {
            return
        }

        if settings.isPiPEnabled {
            settings.playerContext.sendEvent(.enterPiP)
        }
        // create a new event to track purchases
        // replace the values with your data
        let event = PurchaseTrackingEvent(
            orderId: "123", // the order id
            orderValue: 12345.0, // total of all products in the order
            orderProductIds: [product.id], // array of all product ids in the order
            currency: "USD" // the currency used for the order (ISO 4217)
        )
        tracking?.collect(event)
        
        if openPdpInNavigationStack {
            pdpUrl = url
            isPdpOpened = true
            return
        }
        let webView = CustomWebView(url: url) {
            self.onPdpClosed()
        }
        sheet.present(webView)
    }
    
    func onPdpClosed() {
        if settings.isPiPEnabled {
            settings.playerContext.sendEvent(.exitPiP)
        }
    }
    
    func handlePlayerError(_ error: BambuserPlayerSDKError) {
        var errorText = "Unknown error"
        switch error {
        case .showInitialization:
            errorText = "Can't open the show. Please check your 'Show Id' or 'Environment'."
        case .playerInitialization(let error):
            errorText = error?.localizedDescription ?? "-"
        case .openedUrlIsInvalid:
            errorText = error.localizedDescription
        case .unknown(let error):
            errorText = error?.localizedDescription ?? "-"
        }

        alert(title: "Error", message: errorText, buttonText: "Ok") {
            alert.dismiss()
            dismiss()
        }
    }
}


// MARK: - Private Functionality

private extension PlayerScreen {
    
    func alert(
        title: String,
        message: String,
        buttonText: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        let button: Alert.Button? = buttonText != nil ?
            .cancel(Text(buttonText!), action: buttonAction) : nil
        
        alert.present(Alert(
            title: Text(title),
            message: Text(message),
            dismissButton: button
        ))
    }
}


struct PlayerScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        PlayerScreen(
            showCloseButton: false,
            openPdpInNavigationStack: false
        )
        .environmentObject(DemoSettings())
    }
}
