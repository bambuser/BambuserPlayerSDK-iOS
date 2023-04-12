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
    @State var selectedEnvironment: SelectableEnvironment = .auto
    @State var otherEnvironmentName: String = ""
    
    var body: some View {
        Group {
            configurationSection
            upcomingShowsSection
            pipSection
            uiOverlaysSection
            actionBarSection
            curtainsSection
            productsSection
        }
    }

    var configurationSection: some View {
        Section(header: Text("Configuration")) {
            text(.id, "Show ID", $settings.showId)

            picker(
                .globe,
                "Environment",
                options: SelectableEnvironment.allCases.map { $0.rawValue },
                selection: .init(
                    get: { selectedEnvironment.rawValue },
                    set: { selectedEnvironment = .init(rawValue: $0) ?? .auto }
                )
            )
            .onChange(of: otherEnvironmentName) { settings.environment = selectedEnvironment.environment(otherName: $0) }
            .onChange(of: selectedEnvironment) { settings.environment = $0.environment() }

            if selectedEnvironment == .other {
                text(.otherEnvironment, "Other environment name", $otherEnvironmentName)
                    .transition(.opacity)
            }

            toggle(.automatic, "Auto switch to next show", $settings.automaticallyLoadNextShow)
        }
    }

    var upcomingShowsSection: some View {
        Group {
            if settings.automaticallyLoadNextShow {
                Section(header: Text("Upcoming shows")) {
                    ForEach(0..<settings.upcomingShows.count, id: \.self) { index in
                        let text = settings.upcomingShows[index]
                        let iconName = "\(Int(index) + 1).circle.fill"
                        removableText(
                            Image(systemName: iconName),
                            "",
                            $settings.upcomingShows[index],
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
            toggle(.pipExit, "Automatic", $settings.isPiPAutomatic)
            toggle(.rectangle, "Hide UI", $settings.hideUiOnPip)
            toggle(.pipRestore, "Restore automatically", $settings.shouldRestorePiPAutomatically)
        }
    }

    var uiOverlaysSection: some View {
        Section(header: Text("UI Overlays")) {
            toggle(.ui, "All UI", $settings.allUI)
            toggle(.chat, "Show chat overlay", $settings.chatOverlay)
            toggle(.heart, "Show emoji overlay", $settings.emojiOverlay)
            toggle(.product, "Show product list", $settings.productList)
        }
    }

    var actionBarSection: some View {
        Section(header: Text("Action Bar")) {
            toggle(.actionBar, "Show action bar", $settings.actionBar)
            toggle(.heart, "Show emoji button", $settings.emojiButton)
            toggle(.cart, "Show cart button", $settings.cartButton)
            toggle(.chat, "Show chat visibility button", $settings.chatVisibilityButton)
            toggle(.share, "Show share button", $settings.shareButton)
        }
    }

    var curtainsSection: some View {
        Section(header: Text("Curtains")) {
            toggle(.bag, "Show products on curtain", $settings.productsOnCurtain)
        }
    }
    
    var productsSection: some View {
        Section(header: Text("Products")) {
            toggle(.play, "Show product play button", $settings.productPlayButton)
        }
    }
}

private extension SettingsListSection {
    
    func text(_ icon: Image, _ title: String, _ text: Binding<String>) -> some View {
        HStack {
            ListIcon(icon: icon)
            VStack(spacing: 0) {
                if !text.wrappedValue.isEmpty && !title.isEmpty {
                    Text(title)
                        .font(.system(size: 11, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .transition(.opacity.combined(with: .offset(y: 3)))
                }

                TextField(title, text: text)
            }
            .padding(.vertical, 1)
        }
        .animation(.easeOut(duration: 0.25), value: text.wrappedValue)
    }

    func removableText(_ icon: Image, _ title: String, _ text: Binding<String>, onRemove: @escaping () -> ()) -> some View {
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
}

struct ListSettingsSection_Previews: PreviewProvider {
    static var previews: some View {
        SettingsListSection()
    }
}
