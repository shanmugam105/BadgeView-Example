//
//  BadgeView.swift
//  BadgeView-Example
//
//  Created by Sparkout on 14/04/23.
//

import UIKit

class BadgeView: UIView {
    private lazy var baseView: UIView = { .init(frame: self.bounds) }()
    private lazy var gradientView: UIView = { .init(frame: self.bounds) }()
    private lazy var textLabel: UILabel = {
        let radius = min(self.bounds.midX, self.bounds.midY)
        let circleWidth: CGFloat = radius * 0.85 * 2
        let labelWidth = (circleWidth / 2.0) * 2.squareRoot()
        let xyPoint: CGFloat = (self.frame.width - labelWidth) / 2
        let labelFrame: CGRect = CGRect(x: xyPoint, y: xyPoint, width: labelWidth, height: labelWidth)
        let label: UILabel = .init(frame: labelFrame)
        return label
    }()
    var bgColor: UIColor = .red {
        didSet {
            configureView()
        }
    }
    var labelColor: UIColor = .white {
        didSet {
            configureView()
        }
    }
    var gradientSpeed: CGFloat = 2.0 {
        didSet {
            configureView()
        }
    }
    var rotationSpeed: CGFloat = 45.0 {
        didSet {
            configureView()
        }
    }
    
    var isRotate: Bool = false {
        didSet {
            configureView()
        }
    }
    
    var clockWise: Bool = true {
        didSet {
            configureView()
        }
    }
    var font: UIFont? {
        didSet {
            configureView()
        }
    }
    var text: String! {
        didSet {
            configureView()
        }
    }
    
    private func configureView() {
        createBadgeMask()
        createTextLabel()
        createGradientView()
    }
    
    private func createTextLabel() {
        textLabel.removeFromSuperview()
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.textColor = labelColor
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.font = font ?? .systemFont(ofSize: 18, weight: .semibold)
        addSubview(textLabel)
    }
    
    private func createBadgeMask() {
        baseView.removeFromSuperview()
        self.addSubview(baseView)
        baseView.backgroundColor = bgColor
        // Set the center and radius (pure circle rather than rectangle)
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = min(self.bounds.midX, self.bounds.midY)
        
        // Inset radius is the amount that the inner points are inset by
        let insetRadius: CGFloat = radius * 0.85
        
        // Calculate the segment arc sizes
        let circumference: CGFloat = 2 * 3.14 * frame.width / 2 // c = 2πr
        let numberOfPoints = Int(circumference / 10)
        let segmentArcSize = 360.0 / CGFloat(numberOfPoints)
        let arcMid = segmentArcSize / 2.0
        
        // Start at the top of the circle, but subtract half an arc so the outer point is at the top
        var angle = -90.0 - arcMid
        
        // Create the path
        let path = UIBezierPath()
        
        // Move to the inner starting point
        let startPoint = CGPoint(x: center.x + insetRadius * cos(angle.toRadians()) , y: center.y + insetRadius * sin(angle.toRadians()))
        path.move(to: startPoint)
        
        // Loop and draw the jagged points around the circle
        for _ in 0 ..< numberOfPoints {
            
            // Outer point
            let midAngle = angle + arcMid
            let midPoint = CGPoint(x: center.x + radius * cos(midAngle.toRadians()), y: center.y + radius * sin(midAngle.toRadians()))
            path.addLine(to: midPoint)
            
            // Inner point
            let endAngle = angle + segmentArcSize
            let endPoint = CGPoint(x: center.x + insetRadius * cos(endAngle.toRadians()) , y: center.y + insetRadius * sin(endAngle.toRadians()))
            path.addLine(to: endPoint)
            angle += segmentArcSize
        }
        
        // End drawing
        path.close()
        
        // Mask the image view
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        baseView.layer.mask = mask
        isRotate ? baseView.layer.rotate(rotationSpeed: rotationSpeed, clockWise: clockWise) : ()
    }
    
    private func createGradientView() {
        gradientView.removeFromSuperview()
        let gradientLayer: CAGradientLayer = .init()
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.0).cgColor,
                                UIColor.white.withAlphaComponent(0.25).cgColor,
                                UIColor.white.withAlphaComponent(0.0).cgColor]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.frame = self.bounds
        let angle = 45 * CGFloat.pi / 180
        gradientLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        gradientView.transform = CGAffineTransform(scaleX: 10, y: 10)
        gradientView.layer.addSublayer(gradientLayer)
        isRotate ? gradientView.layer.rotate(rotationSpeed: rotationSpeed, clockWise: !clockWise) : ()
        baseView.addSubview(gradientView)
        // Animate
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -bounds.width / 1.3
        animation.toValue = bounds.width / 1.3
        animation.repeatCount = Float.infinity
        animation.duration = self.gradientSpeed
        gradientLayer.add(animation, forKey: "987654321-SOME-KEY")
    }
}

fileprivate extension CGFloat {
    // Convert degrees to radians
    func toRadians() -> CGFloat {
        return self * CGFloat.pi / 180.0
    }
}

fileprivate extension CALayer {
    func rotate(rotationSpeed: CGFloat, clockWise: Bool = true) {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: (clockWise ? Double.pi : -Double.pi) * 2)
        rotation.duration = rotationSpeed
        rotation.isCumulative = true
        rotation.repeatCount = Float.infinity
        self.add(rotation, forKey: "rotationAnimation")
    }
}
