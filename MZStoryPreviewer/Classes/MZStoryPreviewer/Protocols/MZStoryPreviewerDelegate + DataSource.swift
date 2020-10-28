//
//  ZStoryPublisherDelegate + DataSource.swift
//  ZStory publisher Demo
//
//  Created by Mohamed Zead on 10/6/20.
//  Copyright © 2020 Spark Cloud. All rights reserved.
//

import Foundation

//MARK:- MZStoryPreviewerDelegate
public protocol MZStoryPreviewerDelegate {
    func mzStoryPreviewer(_ previewer : MZStoryPreviewer ,didSelectItemAt : Int)
}


//MARK:- MZStoryPreviewerDataSource

public protocol MZStoryPreviewerDataSource{
    func mzStoryPreviewer(storyUsersFor previewer : MZStoryPreviewer)->[MZStoryUser]
}
