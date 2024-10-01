<div>
  <br/><br />
  <p align="center">
    <a href="https://bambuser.com" target="_blank" align="center">
        <img src="https://brand.bambuser.net/current/logo/bambuser-black-512.png" width="280">
    </a>
  </p>
  <br/><br />
</div>

# Bambuser Player SDK

## About

`BambuserPlayerSDK` let's you add a Bambuser Live Video Shopping (LVS) Player to your app.

The LVS player can be used to watch live and recorded shows, with UI overlays that let's users interact with the show.

The LVS player can be configured to great extent and also lets you listen for player emitted events and perform player-specific functions.

`BambuserPlayerSDK` supports iOS and iPadOS 14+ and can be used with `UIKit` and `SwiftUI`.

## Installation

Requires Xcode 15.3 or newer.

### Swift Package Manager

```
https://github.com/bambuser/BambuserPlayerSDK-iOS
```

After installing the SDK, you must import `BambuserPlayerSDK` in every file where you want to use it.

### CocoaPods

Add `BambuserPlayerSDK` to **`Podfile`**

```ruby
target 'MyApp' do
  pod 'BambuserPlayerSDK', '~> 2.0.0'
end
```

### Carthages

This SDK does not support Carthage.

## Prerequisite

This SDK requires [Firebase SDK](https://github.com/firebase/firebase-ios-sdk) as dependency and needs to be added to your project.
`Firebase SDK` will be added along with `BambuserPlayerSDK` through SPM, if not currently available in project.

Minimum required version of `Firebase SDK` is [11.0.0](https://github.com/firebase/firebase-ios-sdk/tree/11.0.0).
If you're project is using an older version, you need to update it or use `BambuserPlayerSDK` [1.5.4](https://github.com/bambuser/BambuserPlayerSDK-iOS/tree/1.5.4) in order to use `BambuserPlayerSDK`.

## Getting started

### Documentation

You can download the latest DocC documentation [here](https://github.com/bambuser/BambuserPlayerSDK-iOS/tree/1.5.4/Docs).
Extract the downloaded file and double-tap the `.doccarchive` file to view the documentation in Xcode.

### UIKit

With `UIKit`, you can create a player like this:

```swift
let player = BambuserPlayerViewController(showId: "The ID of the show to watch")
```

You can then add the player anywhere in your app.

### SwiftUI

With `SwiftUI`, you can create a player like this:

```swift
let player = BambuserPlayerView(showId: "The ID of the show to watch")
```

You can then add the player anywhere in your app, resize it to fit your needs etc.

## Player Configuration

You can use a `PlayerConfiguration` to configure the player instance.

[Read more here][Configuration] to learn about how to configure the player, UI overlays, event listeners etc.

## Player Events

The player will emit `ExternalOutputEvent` values to the event handler that you inject into the player configuration.

[Read more here][Events] to learn about listening for events, extracting data etc.

## Picture-in-Picture

BambuserPlayerSDK supports native picture-in-picture (referred to as `PiP` in the text below).

[Read more here][PictureInPicture] to learn about manual and automatic PiP enabling, PiP restoration etc.

## Conversion tracking

To improve statistics on conversion you can use *Conversion tracking*.

[Read more here][ConversionTracking] to learn about how to set up conversion tracking.

## Multiple players

If you want to display multiple players at the same time, or show them in a scrollable list you might need to add some custom handling.

[Read more here][MultiplePlayers] to learn about how to display multiple players at the same time.

## Localization

To manage the current locale of the player you can use *Localization*.

[Read more here][Localization] to learn about setting up preferred locale and locale priority.

## Demo apps

The `Demo` folder contains a `SwiftUI` and a `UIKit` demo app.

Have a look at these apps for examples on how to add a live shopping player to your app and configure it, handle PiP etc.

[Configuration]: ./Readmes/Configuration.md
[Events]: ./Readmes/Configuration.md#handle-events
[PictureInPicture]: ./Readmes/PictureInPicture.md
[ConversionTracking]: ./Readmes/ConversionTracking.md
[MultiplePlayers]: ./Readmes/MultiplePlayers.md
[Localization]: ./Readmes/Localization.md
