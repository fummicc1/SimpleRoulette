![Images](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/SimpleRoulette.png)

**WARNING: still an alpha version.**

## Demo

![demo](https://github.com/fummicc1/SimpleRoulette/blob/master/Assets/demo.gif)

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

You can choose parts from [RoulettePart.AngleType](https://github.com/fummicc1/SimpleRoulette/blob/master/SimpleRoulette/RoulettePart.swift) or [RoulettePart.HugeType](https://github.com/fummicc1/SimpleRoulette/blob/master/SimpleRoulette/RoulettePart.swift).

### Sample Code

#### With Angle
Create `RoulettePart.AngleType`.

**you can choose radian or angle**


```swift
rouletteView.update(parts: [
    RoulettePart.AngleType(name: "Title A", startAngle: .init(degree: 0), endAngle: .init(degree: 90), index: 0),
    RoulettePart.AngleType(name: "Title B", startAngle: .init(degree: 90), endAngle: .init(degree: 200), index: 1),
    RoulettePart.AngleType(name: "Title C", startAngle: .init(degree: 200), endAngle: .init(degree: 360), index: 2)
])
```

#### With Huge

Create `RoulettePart.AngleType`.

```swift
rouletteView.update(parts: [
    RoulettePart.HugeType(name: "Title A", huge: .large, delegate: rouletteView, index: 0),
    RoulettePart.HugeType(name: "Title B", huge: .normal, delegate: rouletteView, index: 1),
    RoulettePart.HugeType(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
])
```

**IMPORTANT: can not combine Huge with Angle in RouletteView Initializer.**


## License
[MIT LICENSE](https://github.com/fummicc1/SimpleRoulette/blob/master/LICENSE)