//
//  ZStoryUser.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/6/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation


public protocol MZStoryUser{
    var userName : String{get}
    var userImageURLPath : String?{get}
    var userStoryItems : [MZStoryItem]{get}
}
