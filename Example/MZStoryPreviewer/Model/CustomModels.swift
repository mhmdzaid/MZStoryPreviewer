//
//  CustomModel.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/8/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit
import MZStoryPreviewer
/**
 This is a custom struct for the story which confroms to protocol ZStoryItem
  create it  based on your needs
 */

public struct UserStory: MZStoryUser {
    public var userName: String
    public var userImageURLPath: String?
    public var userStoryItems: [MZStoryItem]

    init(data: UserStoryModel) {
        userName = data.name ?? ""
        userImageURLPath = data.image
        userStoryItems = data.stories.map { StoryItemContent($0) }
    }
}

public struct StoryItemContent: MZStoryItem {
    public var duration: TimeInterval = 0.0

    public var image: UIImage?
    public var type: MZStoryItemType = .none
    public var url: URL?

    public init(_ response: StoryItem) {
        url = response.mediaURl
        switch response.type {
        case .image:
            type = .imageLink(response.mediaURl)
            duration = 5.0
        case .video:
            type = .video(response.mediaURl)
            if let url = response.mediaURl {
                let assests = AVAsset(url: url)
                duration = CMTimeGetSeconds(assests.duration)
            }
        }
    }
}
