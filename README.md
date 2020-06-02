![Images](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/SimpleRoulette.png)

**WARNING: still an alpha version.**

## Demo

![demo](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/demo_0_0_2.gif)

## Install

### Swift Package Manager
With SPM, create `Package.swift` and add dependency like below.
```swift
dependencies: [
    .package(url: "https://github.com/fummicc1/SimpleRoulette.git", from: "0.0.1")
]
```

## Usage

1. First, create RouletteView instance.

```swift
let rouletteView: RouletteView = .init(frame: .zero)
```

2. Next, insert parts with `RouletteView().update`.

```
IMPORTANT: you have to call RouletteView().update after view'frame is decided because Title Layer's frame is using view's frame in the internal of library.
```

You can choose parts from [Roulette.AnglePart](https://github.com/fummicc1/SimpleRoulette/blob/master/SimpleRoulette/Source/RoulettePart.swift) or [Roulette.HugePart](https://github.com/fummicc1/SimpleRoulette/blob/master/SimpleRoulette/Source/RoulettePart.swift).

### Sample Code

#### With Angle
Create `Roulette.AnglePart`.

**you can choose radian or angle**


```swift
rouletteView.update(parts: [
    Roulette.AnglePart(name: "Title A", startAngle: .init(degree: 0), endAngle: .init(degree: 90), index: 0),
    Roulette.AnglePart(name: "Title B", startAngle: .init(degree: 90), endAngle: .init(degree: 200), index: 1),
    Roulette.AnglePart(name: "Title C", startAngle: .init(degree: 200), endAngle: .init(degree: 360), index: 2)
])
```

#### With Huge

Create `Roulette.HugePart`.

```swift
rouletteView.update(parts: [
    Roulette.HugePart(name: "Title A", huge: .small, delegate: rouletteView, index: 0),
    Roulette.HugePart(name: "Title B", huge: .large, delegate: rouletteView, index: 1),
    Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
])
```

**IMPORTANT: can not combine Huge with Angle in RouletteView Initializer.**


## License
[MIT LICENSE](https://github.com/fummicc1/SimpleRoulette/blob/master/LICENSE)