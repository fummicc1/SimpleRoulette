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
    let startButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    let hugeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Huge", for: .normal)
        button.addTarget(self, action: #selector(didTapHugePartButton), for: .touchUpInside)
        return button
    }()
    let angleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Angle", for: .normal)
        button.addTarget(self, action: #selector(didTapAnglePartButton), for: .touchUpInside)
        return button
    }()
    lazy var stackView: UIStackView = {
        let stackView: UIStackView = .init(arrangedSubviews: [
           hugeButton,
           startButton,
           angleButton
       ])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rouletteView)
        
        rouletteView.delegate = self
        
        rouletteView.translatesAutoresizingMaskIntoConstraints = false
        rouletteView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rouletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rouletteView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rouletteView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.addSubview(stackView)
        startButton.layer.cornerRadius = 16
        startButton.layer.borderColor = UIColor.systemGray3.cgColor
        startButton.layer.borderWidth = 2
        
        angleButton.layer.cornerRadius = 16
        angleButton.layer.borderColor = UIColor.systemGray3.cgColor
        angleButton.layer.borderWidth = 2
        
        hugeButton.layer.cornerRadius = 16
        hugeButton.layer.borderColor = UIColor.systemGray3.cgColor
        hugeButton.layer.borderWidth = 2
        
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rouletteView.configure(parts: [
            Roulette.HugePart(name: "Title A", huge: .small, delegate: rouletteView, index: 0),
            Roulette.HugePart(name: "Title B", huge: .large, delegate: rouletteView, index: 1),
            Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
            Roulette.HugePart(name: "Title D", huge: .small, delegate: rouletteView, index: 3),
            Roulette.HugePart(name: "Title E", huge: .large, delegate: rouletteView, index: 4),
            Roulette.HugePart(name: "Title F", huge: .normal, delegate: rouletteView, index: 5),
        ])
    }
    
    @objc
    func didTapHugePartButton() {
        rouletteView.configure(parts: [
            Roulette.HugePart(name: "Title A", huge: .small, delegate: rouletteView, index: 0),
            Roulette.HugePart(name: "Title B", huge: .large, delegate: rouletteView, index: 1),
            Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
            Roulette.HugePart(name: "Title D", huge: .small, delegate: rouletteView, index: 3),
            Roulette.HugePart(name: "Title E", huge: .large, delegate: rouletteView, index: 4),
            Roulette.HugePart(name: "Title F", huge: .normal, delegate: rouletteView, index: 5),
        ])
    }
    
    @objc
    func didTapAnglePartButton() {
        rouletteView.configure(parts: [
            Roulette.AnglePart(name: "Title A", startAngle: .init(degree: 0), endAngle: .init(degree: 90), index: 0),
            Roulette.AnglePart(name: "Title B", startAngle: .init(degree: 90), endAngle: .init(degree: 200), index: 1),
            Roulette.AnglePart(name: "Title C", startAngle: .init(degree: 200), endAngle: .init(degree: 240), index: 2),
            Roulette.AnglePart(name: "Title D", startAngle: .init(degree: 240), endAngle: .init(degree: 300), index: 3),
            Roulette.AnglePart(name: "Title E", startAngle: .init(degree: 300), endAngle: .init(degree: 320), index: 4),
            Roulette.AnglePart(name: "Title F", startAngle: .init(degree: 320), endAngle: .init(degree: 360), index: 5),
        ])
    }
    
    @objc
    func didTapStartButton() {
        if rouletteView.isAnimating {
            rouletteView.stop()
        } else {
            rouletteView.start()
        }
        startButton.setTitle(rouletteView.isAnimating ? "Stop" : "Start", for: .normal)
    }
}

extension ViewController: RouletteViewDelegate {
    func rouletteView(_ rouletteView: RouletteView, didStopAt part: RoulettePartType) {
        let alert = UIAlertController(title: "結果", message: part.name, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
