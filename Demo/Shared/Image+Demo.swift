//
//  Image+Demo.swift
//  LiveVideoShoppingPlayer
//
//  Copyright © 2021 Bambuser AB. All rights reserved.
//

import SwiftUI

extension Image {
    
    static let logo = Image("Logo")
    
    static let calendar = image("calendar")
    static let cart = image("cart")
    static let chat = image("bubble.right")
    static let close = image("xmark.circle")
    static let cover = image("rectangle.inset.fill")
    static let heart = image("heart")
    static let link = image("link")
    static let next = image("shuffle.circle")
    static let pip = image("pip")
    static let pipEnter = image("pip.enter")
    static let pipExit = image("pip.exit")
    static let pipRestore = image("arrow.uturn.forward")
    static let player = image("play.rectangle")
    static let product = image("tag")
    static let rectangle = image("rectangle")
    static let share = image("square.and.arrow.up")
    static let sheet = image("rectangle.bottomthird.inset.fill")
    static let subscribe = image("bell")
    static let theme = image("paintpalette")
    static let ui = image("rectangle.3.offgrid")
    static let number = image("number")
    static let actionBar = image("ellipsis.rectangle")
    static let bag = image("bag")
    static let play = image("play.circle")
    static let pause = image("pause.circle")
    static let id = image("textformat.123")
    static let textField = image("square.and.pencil")
    static let globe = image("globe")
    static let server = image("server.rack")
    static let otherEnvironment = image("circle.dotted")
    static let automatic = image("arrow.triangle.2.circlepath")
    static let timestamp = image("clock")
    static let productList = image("rectangle.grid.1x2")
    static let shippingBox = image("shippingbox")
}

private extension Image {

    static func image(_ name: String) -> Image {
        Image(systemName: name)
    }
}
