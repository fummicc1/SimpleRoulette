//
//  IBRouletteViewController.swift
//  SimpleRouletteDemo
//
//  Created by Fumiya Tanaka on 2020/06/03.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit
import SimpleRoulette

class IBRouletteViewController: UIViewController {
    
    @IBOutlet var rouletteView: RouletteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rouletteView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rouletteView.configure(parts: [
            Roulette.HugePart(name: "Title A", huge: .large, delegate: rouletteView, index: 0),
            Roulette.HugePart(name: "Title B", huge: .small, delegate: rouletteView, index: 1),
            Roulette.HugePart(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
            Roulette.HugePart(name: "Title D", huge: .small, delegate: rouletteView, index: 3),
        ])
        
        rouletteView.start()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.rouletteView.stop()
        }
    }
}

extension IBRouletteViewController: RouletteViewDelegate {
    func rouletteView(_ rouletteView: RouletteView, didStopAt part: RoulettePartType) {
        let alert = UIAlertController(title: "結果", message: part.name, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
