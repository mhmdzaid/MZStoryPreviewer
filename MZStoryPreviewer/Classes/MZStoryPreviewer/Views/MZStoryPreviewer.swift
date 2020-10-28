//
//  ZStoryPublisher.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/4/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import UIKit

open class MZStoryPreviewer: UIView {
    @IBInspectable open var storyGradientColors: [UIColor] = [.purple, .orange]
  
    /// delegate protocol for storypreviewer
    open var delegate: MZStoryPreviewerDelegate?
    /// dataSource protocol for storypreviewer
    open var dataSource: MZStoryPreviewerDataSource?
    ///  users returned from dataSource protocol of storypreviewer
    private var users: [MZStoryUser] {
        let users_ = dataSource?.mzStoryPreviewer(storyUsersFor: self) ?? []
        return users_
    }

    internal lazy var storiesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let HEIGHT_WIDTH = frame.height * 0.8
        layout.itemSize = CGSize(width: HEIGHT_WIDTH, height: HEIGHT_WIDTH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MZStoryUserCell.self, forCellWithReuseIdentifier: "userCell")
        return collectionView
    }()

    override open func awakeFromNib() {
        super.awakeFromNib()
        setUpSubViews()
    }

    /// reloads all of the users for storypreviewer
    open func reloadUsers() {
        storiesCollectionView.reloadData()
    }

    // MARK: - SubViews setup

    fileprivate func setUpSubViews() {
        addSubview(storiesCollectionView)
        setStoriesCollectionConstraints()
        storiesCollectionView.delegate = self
        storiesCollectionView.dataSource = self
    }

    fileprivate func setStoriesCollectionConstraints() {
        NSLayoutConstraint.activate([
            storiesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            storiesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            storiesCollectionView.leftAnchor.constraint(equalTo: leftAnchor),
            storiesCollectionView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}

// MARK: - UICollectionView DataSource + Delegate

extension MZStoryPreviewer: UICollectionViewDelegate, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as? MZStoryUserCell else {
            return UICollectionViewCell()
        }
        let user = users[indexPath.item]
        cell.user = user
        cell.storyColors = storyGradientColors
        cell.setUpStrokeifAvailable()
        return cell
    }
    
    

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? MZStoryUserCell else { return }
        cell.storyContentView.animateBorder(1) { [weak self] in
            guard let self = self else { return }
            self.presentStoriesController(userAt: indexPath.item)
            self.delegate?.mzStoryPreviewer(self, didSelectItemAt: indexPath.item)
        }
    }

    /**
     Presents a story View with user stories .
     - Parameter index: index of user in users array
     */
    private func presentStoriesController(userAt index: Int) {
        let user = users[index]
        guard !user.userStoryItems.isEmpty else { return } /// check if user stories is empty
        guard let controller = superview?.parentViewController else { return }
        let storiesVC = MZStoryViewController()
        storiesVC.modalPresentationStyle = .overCurrentContext
        storiesVC.users = users
        storiesVC.startIndex = index
        controller.present(storiesVC, animated: true, completion: nil)
    }
}
