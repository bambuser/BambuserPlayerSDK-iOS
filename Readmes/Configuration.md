# Player Configuration

You can use a `PlayerConfiguration` to configure the player instance. 

The player configuration specifies the following configuration parameters:

* `pipConfig` - The picture-in-picture configuration to use, by default `.standard`.
* `uiConfig` - The UI configuration to use, by default `.minimal`.
* `preferredLocale` - The optional preferred locale of the player.

To configure the player:

UIKit: 
```swift
var config = PlayerConfiguration(
    pipConfig: .standard,
    uiConfig: .minimal,
    preferredLocale: Locale(identifier: "sv-SE")
)

var context = BambuserPlayerContext()

BambuserPlayerViewController(
    showId: "ShowId",
    environment: .global,
    config: config,
    context: context) { event in
        /* Handle event */
    }
```

SwiftUI:

```swift
var config = PlayerConfiguration(
    pipConfig: .standard,
    uiConfig: .minimal,
    preferredLocale: Locale(identifier: "sv-SE")
)

var context = BambuserPlayerContext()

BambuserPlayerView(
    showId: "ShowId",
    environment: .global,
    config: config,
    context: context) { event in
        /* Handle event */
    }
```

## Show ID

The show id is the identifier for the show you are trying to present.


## Environment

The show can be stored on different Bambuser servers and therefore can have different environments. The available environments are:
* `global` - The main environment.
* `eu` - The environment for customers who reside inside the European Union.
* `other` - Can be used for experimental Bambuser servers.
* `nil` - (Default) Setting environment to nil will make the player auto-search for a server with the selected Show ID.

If you are not sure or may change servers in the future, it is safe to leave the environment to `nil` (auto). The downside to not specifying it directly is that it might take up to a couple of seconds for the player to search all environments before it finds the correct show, so setting the environment might improve the loading time before the player starts playing.

## Handle Events

To start listening to the events you add your event handling in the event closure of the player init-method.

The event handler can send the following events:

* `openTosOrPpUrl(let url)` - Triggered when the user taps a link to a terms-of-service or privacy-policy URL
* `openUrlFromChat(let url)` - Triggered when the user taps a link in a chat message
* `openProduct(let product)` - Triggered when the user taps a product and `usePlayerProductView` is false.
* `openShareShowSheet(let url)` - Triggered when the user taps a share button to share the current show.
* `openCart` - Triggered when the user taps the cart icon and `usePlayerCartView` is false.
* `hideCart` - Triggered when the user dismisses the cart view.
* `openCalendar(let calendarEvent)` - Triggered when the user taps the calendar icon the curtain before a show has started
* `close` - Triggered when the user taps the close button.
* `pictureInPictureStateChanged(action: let pipAction)` - Triggered when the state of picture-in-picture changes
* `playButtonTapped` - Triggered when the user taps the play button
* `pauseButtonTapped` - Triggered when the user taps the pause button
* `recievedChatMessages(added: let addedMessages, removed: let removedMessages)` - Triggered when the player has displayed or removed new messages
* `productAddedToCart(let product)` - Triggered when a product is added to the cart from the BambuserPlayer product detail page (PDP).
* `sentChatMessage(let sentChatMessage)` - Triggered when the user sends a chat message
* `productWasHighlighted(let product)` - Triggered when a new product was highlighted
* `replay(let replayInfo)` - Triggered when the user replays the current show using the replay button on the end curtain.


## PlayerUIConfiguration

With the `PlayerUIConfiguration` you can choose to show or hide specific UI elements.

There are two predefined UI configurations you can choose from if you do not want to handle every element separately:
- `minimal` - (default) Will display all UI elements that don't require event handling from the app.
- `full` - Will display all UI elements that are visible by default.

This config specifies the following UI configurations:

* `allUi` - The visibility of all UI in the player, by default `.visible`
* `showNumberOfViewers` - The visibility of the number of viewers label, by default `.visible`
* `closeButton` - The visibility of the close player button, by default `.visible`
* `chatOverlay` - The visibility of the chat overlay, by default `.visible`
* `chatInputField` - The visibility of the chat text input field, by default `.visible`
* `emojiOverlay` - The visibility of the emoji overlay, by default `.visible`
* `productList` - The visibility of the product list, by default `.visible`
* `productListLayout` - The layout of the product list, by default `.modern`
* `actionBar` - The visibility of the action bar, by default `.visible`
* `emojiButton` - The visibility of the emoji button, by default `.visible`
* `cartButton` - The visibility of the cart button, by default `.visible`
* `productsOnEndCurtain` - The visibility of the product list on the end-curtain, by default `.visible`
* `showPDPOnProductTap` - If the player should show the PDP instead of sending an event directly, by default `true`
* `productPlayButton` - The visibility of the "shown at xx:xx" button on PDP, by default `.visible`
* `chatVisibilityButton` - The visibility of the chat visibility button, by default `.visible`
* `chatSize` - The relative size of the chat area. Width/height is in the range of 0...1. By default `nil`
* `shareButton` - The visibility of the share button, by default `.visible`
* `ignoreSystemInsets` - If it's enabled, the safe area and status bar insets are removed. By default `false`
* `usePlayerCartView` - Whether the player should use the built-in Cart view. Default is `true`. If set to `false`, the `openCart` event will be triggered.
* `usePlayerProductView` - Whether the player should use the built-in Product Details view. Default is `true`. If set to `false`, the `openProduct(Product.Base)` event will be triggered.


## PictureInPictureConfiguration

This type specifies the following PiP configurations:

* `isEnabled` - Whether or not picture-in-picture is enabled, by default `true`.
* `isAutomatic` - Whether or not picture-in-picture should autostart, by default `true`.
* `hideUiOnPip`: Whether or not UI should be visible when picture-in-picture is presented, by default `true`

Note: `isAutomatic` is only supported from iOS 14.2 and later.

## Sending events

There is functionality to send events to the player. You do it by the `sendEvent()` method in the `BambuserPlayerContext`:

```swift
let context = BambuserPlayerContext()
let player = BambuserPlayerView(showId: "ShowId", context: context)
context.sendEvent(.enterPiP)
```

The following events are available:
* `enterPiP` - Will open the current video in a picture-in-picture window.
* `exitPiP` - Will close the currently active picture-in-picture window.
* `togglePiP` - Will change to the opposite of the current state of Picture-in-Picture.
* `resume` - Will resume playing the current show.
* `pause` - Will pause the current show.