//
//  IBRouletteViewController.swift
//  SimpleRouletteDemo
//
//  Created by Fumiya Tanaka on 2020/06/03.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit
import SwiftUI
import SimpleRoulette

class IBRouletteViewController: UIViewController {
    
    @IBOutlet var rouletteView: RouletteView!
    @IBOutlet var secondRouletteView: RouletteView!
    @IBOutlet var stackView: UIStackView!
    
    weak var viewModel: RouletteViewModel?
    
    lazy var rouletteSwiftUIViewController: UIViewController = {
        let viewModel = RouletteViewModel(onDecide: { (part) in
            let alert = UIAlertController(title: part.name, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.view.window?.rootViewController?.present(alert, animated: true, completion: nil)
        })
        viewModel.configureParts([
            Roulette.HugePart(name: "Test AAAAAAAAAAAAA", huge: .normal, delegate: viewModel, index: 0, fillColor: UIColor.systemRed),
            Roulette.HugePart(name: "Test B", huge: .normal, delegate: viewModel, index: 1, fillColor: UIColor.systemBlue),
            Roulette.HugePart(name: "Test C", huge: .normal, delegate: viewModel, index: 2, fillColor: UIColor.systemYellow),
            Roulette.HugePart(name: "Test D", huge: .normal, delegate: viewModel, index: 3, fillColor: UIColor.systemGreen),
        ])
        self.viewModel = viewModel
        return UIHostingController(rootView: RouletteViewSwiftUI(viewModel: viewModel))
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rouletteView.delegate = self
        secondRouletteView.delegate = self
        rouletteView.configure(parts: [
            Roulette.HugePart(name: "Title A", huge: .large, delegate: rouletteView, index: 0),
            Roulette.HugePart(name: "Title B", huge: .small, delegate: rouletteView, index: 1),
            Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
        ])

        secondRouletteView.configure(parts: [
            Roulette.HugePart(name: "Title E", huge: .large, delegate: secondRouletteView, index: 0),
            Roulette.HugePart(name: "Title F", huge: .small, delegate: secondRouletteView, index: 1),
            Roulette.HugePart(name: "Title G", huge: .normal, delegate: secondRouletteView, index: 2),
            Roulette.HugePart(name: "Title H", huge: .large, delegate: secondRouletteView, index: 3),
            Roulette.HugePart(name: "Title I", huge: .small, delegate: secondRouletteView, index: 4),
            Roulette.HugePart(name: "Title J", huge: .normal, delegate: secondRouletteView, index: 5),
        ])
        
        stackView.addArrangedSubview(rouletteSwiftUIViewController.view)

        viewModel?.start()
        rouletteView.start()
        secondRouletteView.start(duration: 10)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.rouletteView.stop()
//            self.secondRouletteView.stop()
            self.viewModel?.stop()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let view =  UIView(frame: CGRect(origin: .zero, size: .init(width: 32, height: 32)))
        view.layer.cornerRadius = 16
        view.backgroundColor = .green
        view.layer.masksToBounds = true
        rouletteView.setPointView(view, size: view.frame.size)
    }
}

extension IBRouletteViewController: RouletteViewDelegate {
    func rouletteView(_ rouletteView: RouletteView, didStopAt part: RoulettePartType) {
        let alert = UIAlertController(title: "結果", message: part.name, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        rouletteView.configure(parts: [
            Roulette.HugePart(name: "Title A", huge: .large, delegate: rouletteView, index: 0),
            Roulette.HugePart(name: "Title B", huge: .small, delegate: rouletteView, index: 1),
            Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
        ])
    }
}
