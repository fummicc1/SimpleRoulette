![Images](https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/SimpleRoulette.png)

![Pod Platform](https://img.shields.io/cocoapods/p/SimpleRoulette.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/SimpleRoulette.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/SimpleRoulette.svg?style=flat)](http://cocoapods.org/pods/SimpleRoulette)
![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)

---

## SimpleRoulette

SimpleRoulette helps you to create customizable Roulette, with **SwiftUI**. (Compatible with both MacOS and iOS.)

---

## Demo

```
Because of GiF, demo is a little broken, if you have interests in SimpleRoulette, please check on local machine.
```

|iOS (with `Text` Content)|iOS (with `AnyView(Image)` Content)|
|---|---|
|<img src="https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/Roulette_Ver_SwiftUI.gif" width=320px>|<img src="https://user-images.githubusercontent.com/44002126/159145680-abc1cf83-9860-4a7b-91b5-60122c193973.gif" width=320px>|

|MacOS (with `AnyView(Image)` Content)|
|---|
|<img src="https://user-images.githubusercontent.com/44002126/159145747-29f4e41c-0005-47f3-a343-604d887a3975.gif" width=640px>|


---

## Install

### Swift Package Manager

Create `Package.swift` and add dependency like the following.

```swift
dependencies: [
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", from: "1.0.0")
    // or
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", branch: "main")
]
```

### Cocoapods

Create `Podfile` and add dependency like the following.

```ruby
pod 'SimpleRoulette', '~> 1.0'
```

### Carthage

Create `Cartfile` and add dependency like the following.

```txt
github "fummicc1/SimpleRoulette"
```

---

## Usage


### RouletteView
`RouletteView` confirms to `View`, so you can use it like the follwing.

```swift
struct ContentView: View {

    @ObservedObject var model: RouletteModel

    var body: some View {
        VStack {
            RouletteView(
                model: model
            )
        }
    }
}

// Call ContentView
ContentView(
    model: RouletteModel(duration: 5)
)
```



### RouletteModel
RouletteModel is ObservableObject to manage the state of Roulette. In addition to it, RouletteModel has `onDecide: PassthroughSubject<RoulettePartType, Never>` to send the event when Roulette has stopped.

#### RouletteModel#init
To initialize RouletteModel, you need 3 parameters, `duration`, `onDecide` and `parts'. `onDecide` and `parts` have default values.

```swift
// most simple way
let model = RouletteModel(duration: 5)
// if you want manage `onDecide` event, please generate `PassthroughSubject` by yourself.
let myOnDecide = PassthroughSubject<RoulettePartType, Never> = .init()
let model = RouletteModel(duration: 10, onDecide: myOnDecide)

// Setup parts with `HugePart` right now.
let huges: [Roulette.HugePart.Config] = (0...4).map { index in
    Roulette.HugePart.Config(
        label: "\(index)",
        huge: .normal
    ) {
        AnyView(
            Image(systemName: "\(index).square")
                .resizable()
                .frame(width: 32, height: 32)
        )
    }
}
let model = RouletteModel(
    duration: 5,
    huges: huges
)
```

You can configure `part` after model's initialization.

```swift
viewModel.configureParts([
    Roulette.HugePart.Config(label: "Title A", huge: .large, fillColor: UIColor.systemTeal),
    Roulette.HugePart.Config(label: "Title B", huge: .small, fillColor: UIColor.systemBlue),
    Roulette.HugePart.Config(label: "Title C", huge: .normal, fillColor: UIColor.systemRed),
]
```

---

## Example [Documentation is under construction]

- [DemoApp]()

---

## About RoulettePartType

`RoulettePartType` is either `Roulette.HugePart` or `Roulette.AnglePart`.

Both PartType's initializer has `label`, `index` and `content` parameters in common.

### About Roulette.HugePart

`HugePart` is easier than `AnglePart`.  
We can separate elements intuitively using `Roulette.HugePart.Kind` enum.

When initializing `Roulette.HugePart`, it is recommended to use `Roulette.HugePart.Config` struct and `RouletteModel.configureWithHuge` method.

```swift
let model: RouletteModel
model.configureWithHuge([
    Roulette.HugePart.Config(label: "Title A", huge: .small),
    Roulette.HugePart.Config(label: "Title B", huge: .large),
    Roulette.HugePart.Config(label: "Title C", huge: .normal),
])
```

**IMPORTANT: in current state, it is not possible to combine both `Roulette.HugePart` and `Roulette.AnglePart` in singule `RouletteView`**.

---

## Contributing

Pull requests, bug reports and feature requests are welcome 🚀  

---

## License
[MIT LICENSE](https://github.com/fummicc1/SimpleRoulette/blob/main/LICENSE)
