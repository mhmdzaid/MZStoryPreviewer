//
//  ViewController.swift
//  MZStoryPreviewer
//
//  Created by mozead1996 on 10/28/2020.
//  Copyright (c) 2020 mozead1996. All rights reserved.
//


import UIKit
import MZStoryPreviewer

class ViewController: UIViewController {
    
    @IBOutlet var previewer: MZStoryPreviewer!
    var users: [UserStory] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        /// here we set delegaet and dataSource for the story previewer
        previewer.delegate = self
        previewer.dataSource = self
        getUsers()
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
/// Returns users from Users.json file
    fileprivate func getUsers() {
        do {
            if let path = Bundle.main.path(forResource: "Users", ofType: "json"),
                let jsonData = try String(contentsOfFile: path).data(using: .utf8) {
                let usersResponse = try JSONDecoder().decode(UsersResponse.self, from: jsonData)
                self.users = (usersResponse.users ?? []).map({UserStory.init(data: $0)})
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK:-  MZStoryPreviewer Delegate + DataSource
extension ViewController: MZStoryPreviewerDataSource, MZStoryPreviewerDelegate {
    
    func mzStoryPreviewer(_ previewer: MZStoryPreviewer, didSelectItemAt: Int) {
        
    }
    func mzStoryPreviewer(storyUsersFor previewer: MZStoryPreviewer) -> [MZStoryUser] {
        return users
    }
}

