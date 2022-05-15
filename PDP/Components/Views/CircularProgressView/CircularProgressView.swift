//
//  CircularProgressView.swift
//  PDP
//
//  Created by Евгений Самарин on 15.05.2022.
//

import UIKit

class CircularProgressView: UIView {

    // MARK: - Instance Properties

    public var progress: CGFloat = 0 {
        didSet {
            self.updateProgress()
        }
    }
    
    public var lineWidth: CGFloat?
    public var offset: CGFloat?
    
    public var isEmptyState: Bool? = false
    
    // MARK: -
    
    private var centerPoint: CGPoint = .zero
    private var radius: CGFloat = 0
    private var lastAngel: CGFloat = 0
    
    private let startAngle: CGFloat = -.pi / 2
    private let endAngle: CGFloat = 3 * .pi / 2

    private lazy var progressLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.purple.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = self.lineWidth ?? 0
        shapeLayer.strokeStart = 0
        shapeLayer.strokeEnd = self.progress
        return shapeLayer
    }()

    private lazy var backLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = self.lineWidth ?? 0
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        return shapeLayer
    }()

    private lazy var dotLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = UIBezierPath(arcCenter: .zero, radius: (self.lineWidth ?? 0), startAngle: self.startAngle, endAngle: self.endAngle, clockwise: true).cgPath
        shapeLayer.fillColor = UIColor.purple.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        return shapeLayer
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UIView Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        self.addSublayers()
        self.updatePaths()
        self.updateProgress()
    }

    // MARK: - Instance Methods

    private func addSublayers() {
        guard let isEmptyState = self.isEmptyState else {
            return
        }
        if isEmptyState {
            self.layer.addSublayer(self.backLayer)
            self.layer.addSublayer(self.progressLayer)
        } else {
            self.layer.addSublayer(self.backLayer)
            self.layer.addSublayer(self.progressLayer)
            self.layer.addSublayer(self.dotLayer)
        }
    }

    private func updatePaths() {
        self.centerPoint = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        self.radius = min(self.bounds.width, self.bounds.height) / 2 * 0.83

        let circlePath = UIBezierPath(arcCenter: self.centerPoint, radius: self.radius, startAngle: self.startAngle, endAngle: self.endAngle, clockwise: true)

        self.progressLayer.path = circlePath.cgPath
        self.backLayer.path = circlePath.cgPath
    }

    private func updateProgress() {
        self.progressLayer.strokeEnd = self.progress

        let angle = (self.endAngle - self.startAngle) * self.progress + self.startAngle
        let point = CGPoint(x: self.centerPoint.x + self.radius * cos(angle),
                            y: self.centerPoint.y + self.radius * sin(angle))
        
        self.dotLayer.position = point
        
        let clockwise = self.lastAngel < angle
        let circlePath = UIBezierPath(arcCenter: self.centerPoint, radius: self.radius, startAngle: self.lastAngel, endAngle: angle, clockwise: clockwise)
        self.lastAngel = angle

        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 0.2
        animation.path = circlePath.cgPath

        self.dotLayer.add(animation, forKey: nil)

    }
}

// MARK: - CircularProgressViewInput Methods

extension CircularProgressView: CircularProgressViewInput {
    
}
