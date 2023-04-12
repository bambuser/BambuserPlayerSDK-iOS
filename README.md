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

Requires Xcode 14.0 or newer.

### Swift Package Manager

```
https://github.com/bambuser/BambuserPlayerSDK-iOS
```

After installing the SDK, you must import `BambuserPlayerSDK` in every file where you want to use it.

### CocoaPods

Add ```pod 'BambuserPlayerSDK', :git => 'https://github.com/bambuser/BambuserPlayerSDK-iOS'``` to your Podfile.

### Carthages

This SDK does not support Carthage.



## Getting started

### Documentation

You can download the latest DocC documentation [here][Documentation].

Just extract the downloaded file and double-tap the `.doccarchive` file to view the documentation in Xcode. 


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



## Picture-in-Picture

Bambuser Live Video Shopping Player supports native picture-in-picture (referred to as `PiP` in the text below).

[Read more here][PictureInPicture] to learn about manual and automatic PiP enabling, PiP restoration etc. 



## Demo apps

The `Demo` folder contains a `SwiftUI` and a `UIKit` demo app. 

Have a look at these apps for examples on how to add a live shopping player to your app and configure it, handle PiP etc.



[Documentation]: ./Docs/BambuserPlayerSDK.doccarchive.zip
[ReleaseNotes]: ./RELEASE_NOTES.md

[Configuration]: ./Readmes/Configuration.md
[Events]: ./Readmes/Events.md
[PictureInPicture]: ./Readmes/PictureInPicture.md
