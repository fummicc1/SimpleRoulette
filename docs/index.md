![Images](https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/SimpleRoulette.png)

![Pod Platform](https://img.shields.io/cocoapods/p/SimpleRoulette.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/SimpleRoulette.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/SimpleRoulette.svg?style=flat)](http://cocoapods.org/pods/SimpleRoulette)
![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)

## SimpleRoulette

SimpleRoulette helps you to create customizable Roulette, with SwiftUI. (Compatible with both macOS and iOS.)

## Demo

### iOS

<img src="https://user-images.githubusercontent.com/44002126/180654806-58f70b4f-9bbd-4345-b7a5-4e1ba5aebbd9.gif" width="30%">

### macOS

<img src="https://user-images.githubusercontent.com/44002126/180655023-ccb71dce-9478-4f44-a8c1-b914184e607c.gif" width="30%">

## Install

### Swift Package Manager

Create `Package.swift` and add dependency like the following.

```swift
dependencies: [
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", from: "1.2.0")
    // or
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", branch: "main")
]
```

### Cocoapods

Create `Podfile` and add dependency like the following.

```ruby
pod 'SimpleRoulette', '~> 1.2'
```

### Carthage

Create `Cartfile` and add dependency like the following.

```txt
github "fummicc1/SimpleRoulette"
```

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
        }.onAppear { model.start(speed: .random()) }
    }
}

// Call ContentView
ContentView(
    model: RouletteModel(
        PartData(
            index: 0,
            content: .label("Swift"),
            area: .flex(3),
            fillColor: Color.red
        ),
        PartData(
            index: 1,
            content: .label("Kotlin"),
            area: .flex(1),
            fillColor: Color.purple
        ),
        PartData(
            index: 2,
            content: .label("JavaScript"),
            area: .flex(2),
            fillColor: Color.yellow
        ),
        PartData(
            index: 3,
            content: .label("Dart"),
            area: .flex(1),
            fillColor: Color.green
        ),
        PartData(
            index: 4,
            content: .label("Python"),
            area: .flex(2),
            fillColor: Color.blue
        ),
        PartData(
            index: 5,
            content: .label("C++"),
            area: .degree(60),
            fillColor: Color.orange
        ),
    )
)
```

### RouletteModel

RouletteModel is `ObservableObject`. You can observe the event that roulette has been stopped and what is the stop via `onDecide` Publisher.

## Usage

`RouletteModel.start` function immediately start roulette. If you would stop roulette automatically, please specify the duration in seconds of rotation at `automaticallyStopAfter: Double?` parameter. Default value of `automaticallyStopAfter` is nil which means that roulette continues rotating unless you call `RouletteModel.stop` method.

## Documentation

- [Documentation](https://fummicc1.github.io/SimpleRoulette/SimpleRoulette)

## Contributing

Pull requests, bug reports and feature requests are welcome 🚀

## License

[MIT LICENSE](https://github.com/fummicc1/SimpleRoulette/blob/main/LICENSE)
