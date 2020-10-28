//
//  ZStoryItemCell.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/6/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import AVKit
import UIKit
internal class MZStoryItemCell: UICollectionViewCell {
    private var player: AVPlayer?
    
    private lazy var storyImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    private lazy var videoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal var story: MZStoryItem? {
        didSet {
            setUpViews()
        }
    }
    
    private func setUpViews() {
        guard let item_ = story else { return }
        switch item_.type {
        case .imageLink(let path):
            self.loadImageWithPath(path?.absoluteString)
        case .video(let url):
            self.loadVideoWithURL(url)
        default: break
        }
    }
    
    override var reuseIdentifier: String? {
        return "itemCell"
    }
}

// MARK: - Imagee

private extension MZStoryItemCell {
    func loadImageWithPath(_ path: String?) {
        self.storyImage.isHidden = false
        self.videoView.isHidden = true
        addStoryImageView()
        storyImage.loadImage(path)
    }
    
    func addStoryImageView() {
        addSubview(storyImage)
        NSLayoutConstraint.activate([
            storyImage.topAnchor.constraint(equalTo: topAnchor),
            storyImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            storyImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            storyImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: - Video

private extension MZStoryItemCell {
    func loadVideoWithURL(_ url: URL?) {
        self.storyImage.isHidden = true
        self.videoView.isHidden = false
        addVideoView()
        playVedio(url: url)
    }
    
    func addVideoView() {
        addSubview(videoView)
        NSLayoutConstraint.activate([
            videoView.topAnchor.constraint(equalTo: topAnchor),
            videoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func playVedio(url: URL?) {
        resetPlayer()
        guard let url = url else { return }
        self.player = AVPlayer(url: url)
        
        let videoLayer = AVPlayerLayer(player: self.player)
        videoLayer.frame = self.bounds
        videoLayer.videoGravity = .resizeAspect
        self.videoView.layer.addSublayer(videoLayer)
        self.player?.play()
    }
    
    func resetPlayer() {
        if player != nil {
            player?.pause()
            player?.replaceCurrentItem(with: nil)
            player = nil
        }
    }
}
