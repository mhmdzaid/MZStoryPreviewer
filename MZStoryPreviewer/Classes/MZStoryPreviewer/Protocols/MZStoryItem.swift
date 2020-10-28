//
//  ZStoryItem.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/6/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// MARK: - ZStoryItem

public protocol MZStoryItem {
    var type: MZStoryItemType { get set }
    var image: UIImage? { get }
    var url: URL? { get }
    var duration  : TimeInterval {get set}
}

public enum MZStoryItemType {
    case image(UIImage?)
    case imageLink(URL?)
    case video(URL?)
    case none
}
