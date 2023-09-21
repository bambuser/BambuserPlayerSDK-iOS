# Localization

You can use a `PlayerConfiguration` to pass the preferred locale.
Please note, that if your organization doesn't support the passed locale The Bambuser Player SDK will use its own decision logic to select the most suited localization.

For example, if you pass a preferred locale that will equal to the Swedish locale `Locale(identifier: "sv-SE")` and your organization only supports English (`"en-US"`) and Japanese (`"ja-JP"`) locales, The Bambuser Player SDK will select locale automatically (please see [Priority](#priority) section).

## How to use Preferred Locale

To pass preferred locale you should use the optional property `preferredLocale` in `PlayerConfiguration` class:
```swift
var config = PlayerConfiguration(
    pipConfig: .standard,
    uiConfig: .minimal,
    preferredLocale: Locale(identifier: "sv-SE")
)
```

## Priority

To be sure that used localization will be best suited to the current context The Bambuser Player SDK has some priority for localization.
There is a specific priority, under the hood, for the current localization selection:
1. Localization selected by your app (passed to `PlayerConfiguration` as `preferredLocale` parameter).
2. Localization of the current application.
3. Localization of the current device.
4. Default localization of the Bambuser organization connected to the `showId`.
5. Fallback localization (English (US)).

Note: The Bambuser Player SDK checks if the current organization supports specific localization on each of these steps.
