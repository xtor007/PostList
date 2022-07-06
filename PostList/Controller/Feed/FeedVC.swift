//
//  FeedVC.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 06.07.2022.
//

import UIKit

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Feed"
        APIManager.shared.getAllPosts { posts in
            print(posts)
        } onError: { message in
            print(message)
        }

    }

}
