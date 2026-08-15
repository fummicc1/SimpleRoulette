![Images](https://github.com/fummicc1/SimpleRoulette/blob/main/Assets/SimpleRoulette.png)

![Pod Platform](https://img.shields.io/cocoapods/p/SimpleRoulette.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/SimpleRoulette.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/SimpleRoulette.svg?style=flat)](http://cocoapods.org/pods/SimpleRoulette)
![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)
![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)

## SimpleRoulette

SimpleRoulette helps you to create customizable Roulette, with SwiftUI. (Compatible with both macOS and iOS.)

### Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 6.0+
- Xcode 16.0+

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
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", from: "2.0.0")
    // or
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", branch: "main")
]
```

### Cocoapods

Create `Podfile` and add dependency like the following.

```ruby
pod 'SimpleRoulette', '~> 2.0'
```

### Carthage

Create `Cartfile` and add dependency like the following.

```txt
github "fummicc1/SimpleRoulette"
```

## Usage

### RouletteView

All you need to know is just `RouletteView` and `PartData`.
`RouletteView` conforms to `View`, so you can use it like the following.

```swift
struct ContentView: View {
    @State private var model = RouletteModel(parts: partDatas)
    @State private var result: String = ""

    var body: some View {
        VStack {
            Text(result)
            RouletteView(model: model)
        }
        .onChange(of: model.state) { _, newState in
            if case .stop(let part, _) = newState,
               let text = part.content.text {
                result = text
            }
        }
        .task {
            model.start(speed: .random(), automaticallyStopAfter: 5)
        }
    }
}

let partDatas: [PartData] = [
    PartData(index: 0, content: .label("Swift"), area: .flex(3), fillColor: .red),
    PartData(index: 1, content: .label("Kotlin"), area: .flex(1), fillColor: .purple),
    PartData(index: 2, content: .label("JavaScript"), area: .flex(2), fillColor: .yellow),
    PartData(index: 3, content: .label("Dart"), area: .flex(1), fillColor: .green),
    PartData(index: 4, content: .label("Python"), area: .flex(2), fillColor: .blue),
    PartData(index: 5, content: .label("C++"), area: .degree(60), fillColor: .orange),
]
```

## RouletteModel

`RouletteModel` uses the `@Observable` macro from the Observation framework. You can observe the roulette state directly via `model.state`.

### State Observation

```swift
// Get the decided part when roulette stops
.onChange(of: model.state) { _, newState in
    if case .stop(let part, _) = newState {
        // Handle the result
    }
}

// Or use the convenience property
if let part = model.decidedPart {
    // The roulette has stopped and selected this part
}
```

### Pause / Restart

```swift
struct ContentView: View {
    @State private var model = RouletteModel(parts: partDatas)

    var body: some View {
        VStack {
            RouletteView(model: model)

            HStack {
                Button(model.state.isAnimating ? "Pause" : "Start") {
                    if model.state.isAnimating {
                        model.pause()
                    } else {
                        model.start(speed: .random())
                    }
                }
                Button("Stop") {
                    model.stop()
                }
            }
        }
    }
}
```

### RouletteState

The state machine has four states:

```swift
public enum RouletteState {
    case start                                    // Initial state
    case run(angle: Angle, speed: RouletteSpeed)  // Currently rotating
    case pause(angle: Angle, speed: RouletteSpeed) // Paused mid-rotation
    case stop(location: PartData, angle: Angle)   // Stopped with selected part
}
```

## Documentation

- [Documentation](https://fummicc1.github.io/SimpleRoulette/documentation/simpleroulette)

## Contributing

Pull requests, bug reports and feature requests are welcome 🚀

## License

[MIT LICENSE](https://github.com/fummicc1/SimpleRoulette/blob/main/LICENSE)
