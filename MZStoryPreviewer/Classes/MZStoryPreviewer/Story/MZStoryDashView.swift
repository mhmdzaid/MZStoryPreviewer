//
//  StoryDashView.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/7/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import UIKit

internal class MZStoryDashView: UIView {
    internal var isAnimated: Bool = false
    private lazy var progressBar: UIView = {
        let progressView = UIView()
        progressView.backgroundColor = .white
        progressView.frame = frame
        progressView.frame.size = CGSize(width: 0, height: 2)
        return progressView
    }()

    init() {
        super.init(frame: .zero)
        setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setUpView() {
        backgroundColor = UIColor(white: 1, alpha: 0.5)
        addSubview(progressBar)
    }

    func setAsAnimated() {
        layer.removeAllAnimations()
        progressBar.layer.removeAllAnimations()
    }

    func reset() {
        setAsAnimated()
        progressBar.frame.size.width = 0
    }

    internal func startAnimating(With duration: TimeInterval, _ completion: @escaping () -> ()) {
        var frame_ = progressBar.frame
        let difference = self.frame.width - frame_.size.width
        frame_.size.width += difference
        frame_.size.height = self.frame.size.height
        UIView.animate(withDuration: duration, animations: {
            self.progressBar.frame = frame_
        }, completion: { [weak self] isFinished in
            guard let self = self else { return }
            guard isFinished else { return }
            self.isAnimated = true
            completion()

        })
    }
}
