//
//  FeedVC.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 06.07.2022.
//

import UIKit

class FeedVC: UIViewController {
    
    var posts: [PostInFeed] = []
    
    @IBOutlet weak var postsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Feed"
        fillTable()
        //get data
        APIManager.shared.getAllPosts { posts in
            self.posts = posts
            //reload data in table
            self.postsTable.isHidden = false
            self.postsTable.reloadData()
        } onError: { message in
            print(message)
        }
    }
    
    //function to fill the table
    private func fillTable() {
        postsTable.register(UINib(nibName: PostInFeedCell.nibName, bundle: nil), forCellReuseIdentifier: PostInFeedCell.cellId)
        postsTable.delegate = self
        postsTable.dataSource = self
    }

}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostInFeedCell.cellId, for: indexPath) as? PostInFeedCell {
            cell.initData(posts[indexPath.row])
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}
