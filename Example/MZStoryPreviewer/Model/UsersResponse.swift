//
//  UsersResponse.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/8/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UsersResponse

struct UsersResponse: Codable {
    let users: [UserStoryModel]?
}

// MARK: - Story

public struct UserStoryModel: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let stories: [StoryItem]
}

// MARK: - Story Item

public struct StoryItem: Codable {
    let media: String?
    let type: StoryType
    var mediaURl : URL?{
        return URL.init(string: media?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? "")
    }
}

// MARK: - Story Type

public enum StoryType: String, Codable {
    case image
    case video
    public init(from decoder: Decoder) throws {
        self = try StoryType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .image
    }
}
