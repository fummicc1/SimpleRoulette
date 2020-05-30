//
//  ViewController.swift
//  SimpleRouletteDemo
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit
import SimpleRoulette

class ViewController: UIViewController {
    
    let rouletteView: RouletteView = RouletteView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rouletteView)
        rouletteView.translatesAutoresizingMaskIntoConstraints = false
        rouletteView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rouletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rouletteView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rouletteView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rouletteView.update(parts: [
            .init(name: "Title A", startAngle: RouletteAngle(degree: 0), endAngle: RouletteAngle(degree: 90), index: 0),
            .init(name: "Title B", startAngle: RouletteAngle(degree: 90), endAngle: RouletteAngle(degree: 180), index: 1),
            .init(name: "Title C", startAngle: RouletteAngle(degree: 180), endAngle: RouletteAngle(degree: 360), index: 1)
        ])
    }
}

