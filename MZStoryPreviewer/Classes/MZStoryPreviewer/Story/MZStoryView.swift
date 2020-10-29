//
//  StoryView.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/6/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import UIKit

///  MZStoryView view of  MZStoryViewController
internal class MZStoryView: UIView {
    // MARK: - SubViews
    
    internal lazy var segmentBar: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 3
        return stackView
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("✕", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dimissButtonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func dimissButtonTapped() {
        parentViewController?.dismiss(animated: true, completion: nil)
    }
    
    internal lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = frame.size
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .lightGray
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(MZStoryItemCell.self, forCellWithReuseIdentifier: "itemCell")
        return collectionView
    }()
    
    internal lazy var userImage: UIImageView = {
        let img = UIImageView()
        img.loadImage(users?.first?.userImageURLPath)
        img.layer.cornerRadius = 12.5
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    internal lazy var userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        userNameLabel.text = users?.first?.userName ?? ""
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return userNameLabel
    }()
    
    // MARK: - Initializer and properties
    
    private var stories: [MZStoryItem] = []
    
    private var users: [MZStoryUser]?
    
    init(_ users: [MZStoryUser]?) {
        super.init(frame: UIScreen.main.bounds)
        self.users = users
        (users ?? []).forEach { user in
            stories.append(contentsOf: user.userStoryItems)
        }
        addsubViews()
        setViewConstraints()
        let storiesCount = users?.first?.userStoryItems.count ?? 0
        populatesegmentBar(numberOfStories: storiesCount)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// populates top bar with white bars based on stories number for each user
    internal func populatesegmentBar(numberOfStories num: Int) {
        segmentBar.removeAllArrangedSubviews()
        for _ in 0..<num {
            let dashView = MZStoryDashView()
            dashView.translatesAutoresizingMaskIntoConstraints = false
            dashView.heightAnchor.constraint(equalToConstant: 2).isActive = true
            segmentBar.addArrangedSubview(dashView)
        }
    }
    
    // MARK: - SubViews SetUp
    
    private func addsubViews() {
        addSubview(collectionView)
        addSubview(userImage)
        addSubview(userNameLabel)
        addSubview(segmentBar) // addSubview(segmentBar)
        addSubview(dismissButton)
        bringSubviewToFront(segmentBar)
    }
    
    private func setViewConstraints() {
        NSLayoutConstraint.activate([
            // collectionView Constraints
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            // segmentBar constraints
            segmentBar.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            segmentBar.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 10),
            segmentBar.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentBar.heightAnchor.constraint(equalToConstant: 5),
            // userImage
            userImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userImage.topAnchor.constraint(equalTo: segmentBar.bottomAnchor, constant: 15),
            userImage.widthAnchor.constraint(equalToConstant: 25),
            userImage.heightAnchor.constraint(equalToConstant: 25),
            // userNameLabel
            userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 8),
            userNameLabel.centerYAnchor.constraint(equalTo: userImage.centerYAnchor),
            // Dismiss button
            dismissButton.centerYAnchor.constraint(equalTo: userImage.centerYAnchor),
            dismissButton.widthAnchor.constraint(equalToConstant: 25),
            dismissButton.heightAnchor.constraint(equalToConstant: 25),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
}
