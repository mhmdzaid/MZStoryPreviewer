//
//  ZStoryContentView.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/10/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import UIKit

internal class MZStoryContentView: UIView, CAAnimationDelegate {
    internal var shape: CAShapeLayer?
    internal var gradient : CAGradientLayer?
    private var completion: (() -> ())?
    private var lineWidth: CGFloat = 3.0
    private var gradientColors: [UIColor] = []
    
   internal lazy var storyImageView: UIImageView = {
          let image = UIImageView()
          image.translatesAutoresizingMaskIntoConstraints = false
          image.contentMode = .scaleAspectFill
          image.backgroundColor = .black
          return image
      }()
    
   internal lazy var userNameLabel: UILabel = {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.textAlignment = .center
         label.font = UIFont.systemFont(ofSize: 15)
         return label
     }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.addSubview(storyImageView)
        self.addSubview(userNameLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    override func awakeFromNib() {
          super.awakeFromNib()
         
      }
    
    /// when animation finished  excutes  completion  handler
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        guard flag else { return }
        addCircleGradiendBorder(lineWidth, gradientColors)
        (completion ?? {})()
    }
    /**
        Animates border of the image
         - Parameters:
            - duration : duration of the animation
            -  completion : completion handler for the animation
     */
    internal func animateBorder(_ duration: Double, _ completion: @escaping () -> ()) {
        self.completion = completion
        shape?.strokeStart = 0.0
        shape?.strokeEnd = 0.0
        shape?.lineDashPattern = [5]
        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.delegate = self
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.duration = duration
        strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        strokeEndAnimation.repeatCount = 1
        shape?.add(strokeEndAnimation, forKey: "strokeEndAnimation")
        
    }

    /**
     Adds a cirular gradient border with specified width
         - Parameters :
            - width : width of border of story border.
            - colors : colors used to make gradient color of the border .
     */
    func addCircleGradiendBorder(_ width: CGFloat, _ colors: [UIColor]) {
        lineWidth = width
        gradientColors = colors

        gradient = CAGradientLayer()
        gradient?.frame = CGRect(origin: CGPoint.zero, size: bounds.size)
        let colors: [CGColor] = colors.map { $0.cgColor }
        gradient?.colors = colors
        gradient?.startPoint = CGPoint(x: 1, y: 0.5)
        gradient?.endPoint = CGPoint(x: 0, y: 0.5)
        storyImageView.setToCircular()
        let spacingRect = storyImageView.frame.insetBy(dx: -3, dy: -3)
        let path = UIBezierPath(ovalIn: spacingRect)
        shape = CAShapeLayer()
        shape?.lineWidth = width
        shape?.path = path.cgPath
        shape?.strokeColor = UIColor.black.cgColor
        shape?.lineDashPattern = []
        shape?.fillColor = UIColor.clear.cgColor // clear
        gradient?.mask = shape
        layer.addSublayer(gradient!)//(gradient, below: layer)
    }
    
    
    fileprivate func setUpConstraints() {
          let widthAndHeight = frame.width * 0.7
          NSLayoutConstraint.activate([
              // image view
              storyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
              storyImageView.widthAnchor.constraint(equalToConstant: widthAndHeight ),
              storyImageView.heightAnchor.constraint(equalToConstant: widthAndHeight),
              storyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
              // username label
              userNameLabel.topAnchor.constraint(equalTo: storyImageView.bottomAnchor, constant: 5),
              userNameLabel.centerXAnchor.constraint(equalTo: storyImageView.centerXAnchor),
              userNameLabel.widthAnchor.constraint(equalToConstant: frame.width * 0.8)
          ])
      }
}
