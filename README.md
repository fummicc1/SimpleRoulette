![Images](https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/SimpleRoulette.png)

![Pod Platform](https://img.shields.io/cocoapods/p/SimpleRoulette.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/SimpleRoulette.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/SimpleRoulette.svg?style=flat)](http://cocoapods.org/pods/SimpleRoulette)
![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)

---

## SimpleRoulette

SimpleRoulette helps you to create customizable Roulette, **both UIView and View**.

---

## Demo

|Dark Mode|Light Mode|SwiftUI|
|---|---|---|
|<img src="https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/demo_0.0.2.gif" width=320px>|<img src="https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/demo_0.0.5.gif" width=320px>|<img src="https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/Roulette_Ver_SwiftUI.gif" width=320px>|

---

## Install

### Swift Package Manager

Create `Package.swift` and add dependency like the following.

```swift
dependencies: [
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", from: "0.2.0")
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

### UIKit

#### Initialize RouletteView

##### Without Storyboard/Xib

You can use `RouletteView` without UIStoryboard.

```swift
let rouletteView: RouletteView = .init(frame: .zero)
```

##### With Storyboard/Xib

You can also use `RouletteView` with UIStoryboard or Xib, though it can not visualize until run the code on the device.

```swift
@IBOutlet weak var rouletteView: RouletteView!
```

#### Insert parts with `RouletteView#configure`

You can choose parts from [Roulette.AnglePart](https://github.com/fummicc1/SimpleRoulette/blob/2b0454ebb7d0f89b1a233f4e13ffa1cbe7f677a7/SimpleRoulette/Sources/Common/RoulettePart.swift#L54) or [Roulette.HugePart](https://github.com/fummicc1/SimpleRoulette/blob/2b0454ebb7d0f89b1a233f4e13ffa1cbe7f677a7/SimpleRoulette/Sources/Common/RoulettePart.swift#L26).

```swift
// Using AnglePart
rouletteView.configure(parts: [
    Roulette.AnglePart(name: "Title A", startAngle: .init(degree: 0), endAngle: .init(degree: 90), index: 0),
    Roulette.AnglePart(name: "Title B", startAngle: .init(degree: 90), endAngle: .init(degree: 200), index: 1),
    Roulette.AnglePart(name: "Title C", startAngle: .init(degree: 200), endAngle: .init(degree: 360), index: 2)
])

// Using HugePart
rouletteView.configure(parts: [
    Roulette.HugePart(name: "Title A", huge: .small, delegate: rouletteView, index: 0),
    Roulette.HugePart(name: "Title B", huge: .large, delegate: rouletteView, index: 1),
    Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
])
```

#### Start Roulette by `RouletteView#start`

You can start Roulette by `start(duration: clockwise: animated:)` method.

Implementation is [here](https://github.com/fummicc1/SimpleRoulette/blob/2b0454ebb7d0f89b1a233f4e13ffa1cbe7f677a7/SimpleRoulette/Sources/UIKit/RouletteView.swift#L113).

```swift
rouletteView.start(duration: 2)
```

##### Parameters

|Arguments|Description|Default Value|
|---|---|---|
|duration|Duration|`2`|
|clockwise|Boolen value that is used when `UIBezierPath#addArc`|`true`|
|animated|Boolen value that should be animated|`true`|

#### Stop Roulette by `RouletteView#stop`

You can stop Roulette by `stop` method.

Implementation is [here](https://github.com/fummicc1/SimpleRoulette/blob/2b0454ebb7d0f89b1a233f4e13ffa1cbe7f677a7/SimpleRoulette/Sources/UIKit/RouletteView.swift#L129).

As RouletteView does not automatically stop, you have to call `RouletteView#stop` if you want !

```swift
rouletteView.start()
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    // RouletteView is animating for 3 seconds.
    self.rouletteView.stop()
}
```

#### Implement RouletteViewDelegate

`RouletteViewDelegate` informs you when Roulette has been stopped.

So you should set self, or something, as `RouletteViewDelegate` and add `func rouletteView(_: didStopAt:)` implementation.

```swift
rouletteView.delegate = self

extension HogeViewController: RouletteViewDelegate {
    func rouletteView(_ rouletteView: RouletteView, didStopAt part: RoulettePartType) {
        let alert = UIAlertController(title: "結果", message: part.name, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
```

### SwiftUI

Documentation is not ready. I am looking forward to getting PullRequest :)

Mainly, you use `` and ``.

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

- [UIKit without Storyboard](https://github.com/fummicc1/SimpleRoulette/tree/v0.2.0/SimpleRouletteDemo)
- [UIKit with Storyboard](https://github.com/fummicc1/SimpleRoulette/tree/v0.2.0/SimpleRouletteDemoStoryboard)
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
