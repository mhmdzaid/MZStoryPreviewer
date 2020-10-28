//
//  StoryViewController.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/6/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import UIKit

internal class MZStoryViewController: UIViewController {
    // MARK: - properties

    internal var users: [MZStoryUser]?
    internal var startIndex: Int = 0 /// index of user which is selected from users collection
    private var startingFlag: Bool = false /// flag to prevent willDisplayCell method to called twice during presenting  collectionView
    private var View: MZStoryView?

    // MARK: - View

    override func loadView() {
        setUpView()
        addGestures()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let startingIndexPath = IndexPath(item: 0, section: startIndex)
        View?.collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            self.startingFlag = true
            self.View?.collectionView.scrollToItem(at: startingIndexPath, at: .centeredHorizontally, animated: true)
        })
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    fileprivate func setUpView() {
        guard let users_ = users else { return }
        View = MZStoryView(users_)
        view = View
        view.backgroundColor = .clear
        view.isOpaque = false
        View?.collectionView.delegate = self
        View?.collectionView.dataSource = self
    }

    // MARK: - Gestures

    fileprivate func addGestures() {
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didDragStory(_:))))
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapStory(_:))))
    }

    @objc private func didDragStory(_ sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: view)
        switch sender.state {
        case .changed:
            handleSenderState(changeFor: point)
        case .ended:
            handleSenderState(endedFor: point)
        default:
            break
        }
    }

    @objc private func didTapStory(_ sender: UITapGestureRecognizer) {
        guard let indexPath = View?.collectionView.indexPathsForVisibleItems.first else { return }
        let bars = self.View!.segmentBar.arrangedSubviews.map { $0 as! MZStoryDashView }
        let barToAnimate = bars[indexPath.item]
        let point = sender.location(in: sender.view)
        if point.x > view.frame.midX { /// if user tap to show next story
            barToAnimate.setAsAnimated()
            showNextStory(at: indexPath)

        } else { /// show previous story
            barToAnimate.reset()
            showPreviousStory(at: indexPath)
        }
    }

    private func handleSenderState(changeFor point: CGPoint) {
        guard point.y > 0 else { return }
        UIView.animate(withDuration: 0.0) {
            self.view.transform = CGAffineTransform(translationX: 0, y: point.y)
            self.view.alpha = 1 - point.y / 1000
        }
    }

    private func handleSenderState(endedFor point: CGPoint) {
        if point.y > 150 {
            dismiss(animated: true)
        } else {
            view.transform = .identity
            view.alpha = 1
        }
    }
}

// MARK: - CollectionView Delegate + DataSource

extension MZStoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users?[section].userStoryItems.count ?? 0
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return users?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as? MZStoryItemCell else { return UICollectionViewCell() }
        cell.story = users?[indexPath.section].userStoryItems[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard startingFlag else { return }
        setInfoFor(userAt: indexPath)
        if indexPath.item == 0 { /// if first story of user we repopulate the topBar with stories count number .
            let storiesCount = users?[indexPath.section].userStoryItems.count ?? 0
            View?.populatesegmentBar(numberOfStories: storiesCount)
        }
        animate(barAt: indexPath)
    }

    /**
        Looking for bar related to current IndexPath to animate
        - Parameters :
            - indexPath : indexPath of current visible story to animate it's
     */
    private func animate(barAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            guard let self = self else { return }
            let bars = self.View!.segmentBar.arrangedSubviews.map { $0 as! MZStoryDashView } /// get array of top bars
            let index_ = indexPath.item /// get current stories bar index
            guard index_ < bars.count else { return }
            let animatableBar = bars[index_]
            self.animateBar(animatableBar, indexPath)
        }
    }

    /**
        Loads  user data (name , image),
         - Parameters :
                - index : indexPath of current Cell to get user data
     */
    private func setInfoFor(userAt index: IndexPath) {
        guard let user = users?[index.section] else { return }
        View?.userNameLabel.text = user.userName
        View?.userImage.loadImage(user.userImageURLPath)
    }

    /**
        Animates segmentBar with the specified index
        - Parameters :
                - bar : bar to be animated
                - index : bar's index
     */
    private func animateBar(_ bar: MZStoryDashView, _ index: IndexPath, _ duration: Double? = nil) {
        guard let story = users?[index.section].userStoryItems[index.item] else { return }
        let duration_ = duration == nil ? story.duration : duration
        bar.startAnimating(With: duration_!) { [weak self] in
            guard let self = self else { return }
            self.showNextStory(at: index)
        }
    }

    /**
     shows next story of specified index
        -   Parameters:
            - index: Index of current item to show its next
     */
    fileprivate func showNextStory(at index: IndexPath) {
        let lastStoryIndex = (users?[index.section].userStoryItems.count ?? 0) - 1
        let section_ = index.item == lastStoryIndex ? index.section + 1 : index.section /// if last users story increment to next section
        let item_ = index.item == lastStoryIndex ? 0 : index.item + 1 /// if last user's story then next will be 0 in the next section else increase by 1
        let indexPath_ = IndexPath(item: item_, section: section_)
        View?.collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            self.View?.collectionView.scrollToItem(at: indexPath_, at: .centeredHorizontally, animated: true)
            }) { _ in
            let lastUserIndex = (self.users?.count ?? 0) - 1
            if index.section == lastUserIndex, index.item == lastStoryIndex { ///  if last item of last user  we should dismiss user's story
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    /**
     shows previous story of specified index
        -   Parameters:
            - index: Index of current item to show its previous
     */
    fileprivate func showPreviousStory(at index: IndexPath) {
        var item_: Int = 0
        var section_: Int = 0
        if index.section > 0 {
            let lastStoryIndexOfPreviousUser = (users?[index.section - 1].userStoryItems.count ?? 0) - 1
            section_ = index.item == 0 ? index.section - 1 : index.section
            item_ = index.item == 0 ? lastStoryIndexOfPreviousUser : index.item - 1
        } else {
            item_ = index.item == 0 ? 0 : index.item - 1
            let indexPath = IndexPath(item: item_, section: section_)
            animate(barAt: indexPath) /// if first section reanimate the first bar
        }

        let indexPath_ = IndexPath(item: item_, section: section_)
        fillViewedBars(indexPath_)
        View?.collectionView.performBatchUpdates({ [weak self] in
            guard let self = self else { return }
            self.View?.collectionView.scrollToItem(at: indexPath_, at: .centeredHorizontally, animated: true)
        })
    }

    /**
        Fills  bars with white color  for current user as Viewed stories when showing previous story
     */
    fileprivate func fillViewedBars(_ indexPath: IndexPath) {
        let currentUserStoryCount = users?[indexPath.section].userStoryItems.count ?? 0
        View?.populatesegmentBar(numberOfStories: currentUserStoryCount)
        for i in 0..<currentUserStoryCount {
            if i != indexPath.item, i < indexPath.item {
                (View?.segmentBar.arrangedSubviews[i] as? MZStoryDashView)?.backgroundColor = .white
            }
        }
    }
}
