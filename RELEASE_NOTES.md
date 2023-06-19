# Release Notes

## 1.1.0

### ✨ New features
* Allows presentation of a product details page (PDP)
* New UI-config variable `showPDPOnProductTap` used to choose if the new PDP view should be visible when tapping a product
* Support for password protected shows
* Improved accessibility

We have also squashed some bugs 🐛

## 1.0.0

This version features a complete native rewrite of the BambuserPlayerSDK.
If you used the previous library (BambuserLiveVideoShoppingPlayer-iOS), expect all previous implementations to be obsolete.

### ✨ New features

* The BambuserPlayerSDK is now completely rewritten in pure Swift with SwiftUI as UI-framework.
* Player V2.0 design
    * Includes infinite highlighted products timeline
    * More modern design
* PiP context handling is now done internally, so you only need to handle restoring functionality.
* Possibility to hide even more of the UI through config

### 💥 Breaking changes

* Most previous implementations will need to be redone
* Cart integration is removed (will be readded in a future version)
* Themeing is removed (will be readded in a future version)
* The player only works in portrait mode for iPhone. Still works in all orientations for iPad.

### 🐛 Known bugs

* In some cases the video may fail to display a stream and instead show a black background on simulators.