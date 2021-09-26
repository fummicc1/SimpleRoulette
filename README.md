![Images](https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/SimpleRoulette.png)

![Pod Platform](https://img.shields.io/cocoapods/p/SimpleRoulette.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/SimpleRoulette.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/SimpleRoulette.svg?style=flat)](http://cocoapods.org/pods/SimpleRoulette)
![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)

---

## SimpleRoulette

SimpleRoulette helps you to create customizable Roulette, with **SwiftUI**.

---

## Demo

|SwiftUI|
|---|
|<img src="https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/Roulette_Ver_SwiftUI.gif" width=320px>|

---

## Install

### Swift Package Manager

Create `Package.swift` and add dependency like the following.

```swift
dependencies: [
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", from: "0.2.0")
    // or
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", branch: "main")
]
```

### Cocoapods

Create `Podfile` and add dependency like the following.

```ruby
pod 'SimpleRoulette', '~> 0.2'
```

### Carthage

Create `Cartfile` and add dependency like the following.

```txt
github "fummicc1/SimpleRoulette"
```

---

## Usage

### SwiftUI

Documentation works in progress. I am looking forward to getting PullRequest :)

#### RouletteViewSwiftUI
`RouletteViewSwiftUI` confirms to `View`, so you can use it like the follwing.

```swift
struct ContentView: View {
    var body: some View {
        VStack {
            RouletteViewSwiftUI(viewModel: RouletteViewModel(duration: 5))
        }
    }
}
```

As for `RouletteViewModel`, please check [RouletteViewModel]()

#### RouletteViewModel
RouletteViewModel is ObservableObject to store the state of Roulette. In addition to it, RouletteViewModel has `onDecide: PassthroughSubject<RoulettePartType, Never>` to oberve when Roulette has stopped. About RoulettePartType, please check [About RoulettePatyType](https://github.com/fummicc1/SimpleRoulette#about-rouletteparttype)

##### RouletteViewModel#init
To initialize ROuletteViewMdel, you can no more than two params, `duration` and `onDecide`. `onDecide` can be saved.

```swift
let viewModel = RouletteViewModel(duration: 5)
```

Actually, though initializing is easy, you should configure content of Roulette by `RouletteViewModel#configureParts(_:)`.

```swift
viewModel.configureParts([
    Roulette.HugePart(name: "Title A", huge: .large, delegate: viewModel, index: 0, fillColor: UIColor.systemTeal),
    Roulette.HugePart(name: "Title B", huge: .small, delegate: viewModel, index: 1, fillColor: UIColor.systemBlue),
    Roulette.HugePart(name: "Title C", huge: .normal, delegate: viewModel, index: 2, fillColor: UIColor.systemRed),
]
```

---

## Example [WIP]

- [SwiftUI](https://github.com/fummicc1/SimpleRoulette/tree/v0.2.0/SimpleRouletteDemoSwiftUI)

---

## About RoulettePartType

`RoulettePartType` is either `Roulette.HugePart` or `Roulette.AnglePart`.

Both PartType's initializer has `name` and `index` parameters in common.

### About Roulette.AnglePart

This struct's initializer has `start` and `end` degrees in addition to common args.

```swift
rouletteView.configure(parts: [
    Roulette.AnglePart(name: "Title A", startAngle: .init(degree: 0), endAngle: .init(degree: 90), index: 0),
    Roulette.AnglePart(name: "Title B", startAngle: .init(degree: 90), endAngle: .init(degree: 200), index: 1),
    Roulette.AnglePart(name: "Title C", startAngle: .init(degree: 200), endAngle: .init(degree: 360), index: 2)
])
```

If you think configuring each degree is troublesome, it's time to use `Roulette.HugePart`.

### About Roulette.HugePart

This struct's initializer has neither `start` nor `end`.
Instead of them, it has `huge` and `delegate` parameters which makes you to configure percentage of each RoulettePart intuitively。

you set `RouletteView` as `delegate` while using UIKit.

```swift
rouletteView.configure(parts: [
    Roulette.HugePart(name: "Title A", huge: .small, delegate: rouletteView, index: 0),
    Roulette.HugePart(name: "Title B", huge: .large, delegate: rouletteView, index: 1),
    Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
])
```

**IMPORTANT: can not combine Huge with Angle in RouletteView().configure.**

---

## Contributing

Pull requests, bug reports and feature requests are welcome 🚀  

---

## License
[MIT LICENSE](https://github.com/fummicc1/SimpleRoulette/blob/main/LICENSE)
