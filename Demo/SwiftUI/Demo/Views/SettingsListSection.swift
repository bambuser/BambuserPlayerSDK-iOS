//
//  SettingsListSection.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import SwiftUI
import BambuserPlayerSDK

/**
 This view can be injected into a list to provide a settings
 section for the demo experience.
 */
struct SettingsListSection: View {
    
    @EnvironmentObject private var settings: DemoSettings
    @State var preferredLocaleIdentifier: String = ""
    @State var selectedEnvironment: SelectableEnvironment = .auto
    @State var otherEnvironmentName: String = ""
    
    var playerIsVisible: Bool
    
    var body: some View {
        Group {
            localizationSection
            configurationSection
            upcomingShowsSection
            pipSection
            uiOverlaysSection
            actionBarSection
            productsSection
        }
        .onAppear {
            setup()
        }
    }

    var localizationSection: some View {
        Section(header: Text("Localization")) {
            text(
                .globe,
                "Preferred locale", $preferredLocaleIdentifier
            )
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .onChange(of: preferredLocaleIdentifier) { newValue in
                settings.preferredLocale = Locale(identifier: newValue)
            }
        }
    }
    
    var configurationSection: some View {
        Section(header: Text("Configuration")) {
            text(.id, "Show ID", $settings.showId)

            picker(
                .server,
                "Environment",
                options: SelectableEnvironment.allCases.map { $0.rawValue },
                selection: .init(
                    get: { selectedEnvironment.rawValue },
                    set: { newValue in
                        withAnimation {
                            selectedEnvironment = .init(rawValue: newValue) ?? .auto
                        }
                    }
                )
            )
            .accessibilityLabel("Select current environment")
            .onChange(of: otherEnvironmentName) {
                settings.environment = selectedEnvironment.environment(otherName: $0)
            }
            .onChange(of: selectedEnvironment) {
                settings.environment = $0.environment(otherName: otherEnvironmentName)
            }

            if selectedEnvironment == .other {
                text(.otherEnvironment, "Other environment name", $otherEnvironmentName)
                    .transition(.opacity)
            }

            toggle(.automatic, "Auto switch to next show", .init(get: {
                settings.automaticallyLoadNextShow
            }, set: { newVal in
                withAnimation {
                    settings.automaticallyLoadNextShow = newVal
                }
            }))
        }
    }

    var upcomingShowsSection: some View {
        Group {
            // don't update this section if another screen is opened
            if settings.automaticallyLoadNextShow && !playerIsVisible {
                Section(header: Text("Upcoming shows")) {
                    ForEach(0..<settings.upcomingShows.count, id: \.self) { index in
                        let iconName = "\(Int(index) + 1).circle.fill"
                        let textSafe = Binding<String>(
                            get: {
                                settings.upcomingShows[safe: index] ?? ""
                            },
                            set: {
                                settings.upcomingShows[safe: index] = $0
                            }
                        )
                        removableText(
                            Image(systemName: iconName),
                            "",
                            textSafe,
                            onRemove: { settings.upcomingShows.remove(at: index) })
                    }

                    Button {
                        withAnimation(.easeOut) {
                            if settings.upcomingShows.last != "" {
                                settings.upcomingShows.append("")
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
    }

    var pipSection: some View {
        Section(header: Text("Picture-in-picture"), footer: Text("Picture-in-picture only works on real devices.")) {
            toggle(.pipEnter, "Enabled", $settings.isPiPEnabled)
                .accessibilityLabel("Enable Picture in Picture mode")
            toggle(.pipExit, "Automatic", $settings.isPiPAutomatic)
                .accessibilityLabel("Enable Picture in Picture autostart")
            toggle(.rectangle, "Hide UI", $settings.hideUiOnPip)
                .accessibilityLabel("Hide all player UI controls")
            toggle(.pipRestore, "Restore automatically", $settings.shouldRestorePiPAutomatically)
                .accessibilityLabel("Restore Picture in Picture automatically")
        }
    }

    var uiOverlaysSection: some View {
        Section(header: Text("UI Overlays")) {
            toggle(.ui, "All UI", $settings.allUI)
            toggle(.number, "Show number of viewers", $settings.showNumberOfViewers)
            toggle(.chat, "Show chat overlay", $settings.chatOverlay)
            toggle(.heart, "Show emoji overlay", $settings.emojiOverlay)
            toggle(.bag, "Show product list", $settings.productList)
            picker(
                .productList,
                "Product list",
                options: PlayerUIConfiguration.HighlightedProductsLayout.allCases.map({ $0.rawValue }),
                selection: .init(
                    get: { settings.productListLayout.rawValue },
                    set: { newValue in
                        withAnimation {
                            settings.productListLayout = .init(
                                rawValue: newValue,
                                date: settings.productListLayoutDate
                            )
                        }
                    }
                ))

            if settings.productListLayout.isAutomatic {
                datePicker(
                    .calendar,
                    "Product list breaking point date",
                    selection: .init(
                        get: { settings.productListLayoutDate },
                        set: { newValue in
                            settings.productListLayoutDate = newValue
                            settings.productListLayout = .configurable(date: newValue)
                        }
                    )
                )
            }
        }
    }

    var actionBarSection: some View {
        Section(header: Text("Action Bar")) {
            toggle(.actionBar, "Show action bar", $settings.actionBar)
            toggle(.heart, "Show emoji button", $settings.emojiButton)
            toggle(.cart, "Show cart button", $settings.cartButton)
            toggle(.chat, "Show chat visibility button", $settings.chatVisibilityButton)
            toggle(.textField, "Show chat input field", $settings.chatInputField)
            toggle(.share, "Show share button", $settings.shareButton)
        }
    }

    var productsSection: some View {
        Section(header: Text("Products")) {
            toggle(.product, "Open PDP on product tap", $settings.showPDPOnProductTap)
            toggle(.bag, "Show products on curtain", $settings.productsOnCurtain)
            toggle(.timestamp, "Show product play button", $settings.productPlayButton)
        }
    }
}

private extension SettingsListSection {
    func setup() {
        if let localeId = settings.preferredLocale?.identifier {
            preferredLocaleIdentifier = localeId
        }
    }
}

private extension SettingsListSection {
    
    func text(_ icon: Image, _ title: String, _ text: Binding<String>) -> some View {
        HStack {
            ListIcon(icon: icon)
                .accessibilityHidden(true)
            VStack(spacing: 0) {
                if !text.wrappedValue.isEmpty && !title.isEmpty {
                    Text(title)
                        .font(.system(size: 11, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity.combined(with: .offset(y: 3)))
                        .accessibilityHidden(true)
                }

                TextField(title, text: text)
                    .accessibilityLabel(title)
            }
            .padding(.vertical, 1)
        }
        .animation(.easeOut(duration: 0.25), value: text.wrappedValue)
    }

    func removableText(_ icon: Image, _ title: String, _ text: Binding<String>, onRemove: @escaping () -> Void) -> some View {
        HStack {
            self.text(icon, title, text)

            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .onTapGesture {
                    withAnimation(.easeOut, onRemove)
                }
        }
    }
    
    func toggle(_ icon: Image, _ title: String, _ state: Binding<Bool>) -> some View {
        HStack {
            ListIcon(icon: icon)
            Toggle(title, isOn: state)
        }
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue("\(state.wrappedValue ? 1 : 0)")
        .accessibilityAddTraits(.isButton)
        .onTapGesture {
            state.wrappedValue = !state.wrappedValue
        }
    }

    func picker(_ icon: Image, _ title: String, options: [String], selection: Binding<String>) -> some View {
        HStack {
            ListIcon(icon: icon)
            Picker(selection: selection, label: Text(title)) {
                ForEach(options, id: \.self) { item in
                    Text(item.capitalized)
                }
            }
        }
    }

    func datePicker(_ icon: Image, _ title: String, selection: Binding<Date>) -> some View {
        HStack {
            ListIcon(icon: icon)
            DatePicker(selection: selection, displayedComponents: [.date], label: { Text(title) })
        }
    }
}

struct ListSettingsSection_Previews: PreviewProvider {
    static var previews: some View {
        SettingsListSection(playerIsVisible: false)
    }
}
