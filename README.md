![Images](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/SimpleRoulette.png)

![Pod Platform](https://img.shields.io/cocoapods/p/SimpleRoulette.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/SimpleRoulette.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/SimpleRoulette.svg?style=flat)](http://cocoapods.org/pods/SimpleRoulette)
![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)

---

## SimpleRoulette
SimpleRoulette helps you to create customizable Roulette **both UIView and View**.

---

## Demo

![demo](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/demo_0.0.2.gif)
![demo](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/demo_0.0.5.gif)

---

## Install

### Swift Package Manager
Create `Package.swift` and add dependency like following.
```swift
dependencies: [
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", from: "0.2.0")
]
```

### Cocoapods
Create `Podfile` and add dependency like following.
```ruby
pod 'SimpleRoulette', '~> 0.2'
```

### Carthage
Create `Cartfile` and add dependency like following.
```
github "fummicc1/SimpleRoulette"
```
---

## Usage

### UIKit without Storyboard

1. First, create RouletteView instance.

```swift
let rouletteView: RouletteView = .init(frame: .zero)
```

2. Next, insert parts with `RouletteView#.configure`.

You can choose parts from [Roulette.AnglePart](https://github.com/fummicc1/SimpleRoulette/blob/41d77fb2a98f0112a13b1e5fa58ed096bd572142/SimpleRoulette/Sources/RoulettePart.swift#L57) or [Roulette.HugePart](https://github.com/fummicc1/SimpleRoulette/blob/41d77fb2a98f0112a13b1e5fa58ed096bd572142/SimpleRoulette/Sources/RoulettePart.swift#L29).

1. Start Roulette by `RouletteView#.start`.

You can check if Rotating via `RouletteView().isAnimating`.

4. Stop Roulette by `RouletteView#.stop`

5. Detect when stopping roulette using `RouletteViewDelegate`.

### UIKit with Storyboard
you can use RouletteView with Storyboard.

```swift
@IBOutlet weak var rouletteView: RouletteView!
```

### SwiftUI
Documentation is not ready. please contribute if possilble :)

---

## Example [WIP]
- [UIKit without Storyboard](https://github.com/fummicc1/SimpleRoulette/tree/v0.2.0/SimpleRouletteDemo)
- [UIKit with Storyboard](https://github.com/fummicc1/SimpleRoulette/tree/v0.2.0/SimpleRouletteDemoStoryboard)
- [SwiftUI](https://github.com/fummicc1/SimpleRoulette/tree/v0.2.0/SimpleRouletteDemoSwiftUI)


---

## About RoulettePartType
`RoulettePartType` is either `Roulette.Huge` or `Roulette.AnglePart`.

### About Roulette.AnglePart
This struct needs both degrees from start to end precisely like the following.

```swift
rouletteView.configure(parts: [
    Roulette.AnglePart(name: "Title A", startAngle: .init(degree: 0), endAngle: .init(degree: 90), index: 0),
    Roulette.AnglePart(name: "Title B", startAngle: .init(degree: 90), endAngle: .init(degree: 200), index: 1),
    Roulette.AnglePart(name: "Title C", startAngle: .init(degree: 200), endAngle: .init(degree: 360), index: 2)
])
```

If you think configuring each degree is a bit of troublesome, please use `Roulette.HugePart`.

### About Roulette.HugePart
This struct does not need both degrees from start to end precisely like the following.
Just, specify `delegate` and `kind`.

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
[MIT LICENSE](https://github.com/fummicc1/SimpleRoulette/blob/master/LICENSE)
