//
//  HomeViewController.swift
//  BadgeView-Example
//
//  Created by Sparkout on 14/04/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var badgeView: BadgeView!
    override func viewDidLoad() {
        super.viewDidLoad()
        badgeView.bgColor = .red
        badgeView.text = "10% Offer"
        badgeView.clockWise = false
        badgeView.isRotate = true
        badgeView.labelColor = .white
        badgeView.gradientSpeed = 1.0
        badgeView.rotationSpeed = 45.0
        badgeView.font = .systemFont(ofSize: 24)
    }
}

