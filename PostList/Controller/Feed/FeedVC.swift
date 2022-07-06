//
//  FeedVC.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 06.07.2022.
//

import UIKit

class FeedVC: UIViewController {
    
    var posts = [PostInFeed]()
    var postsTruncatedValues = [TrancatedValue]()
    
    @IBOutlet weak var postsTable: UITableView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    private var sortMenu: UIMenu {
        return UIMenu(title: "firstly show", image: nil, identifier: nil, options: [], children: [
            UIAction(title: "Popular", image: nil, handler: { (_) in
            }),
            UIAction(title: "New", image: nil, handler: { (_) in
            })
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        
        //sort button
        let imageForMenu = UIImage(named: "sort")?.resized(to: CGSize(width: 35, height: 35))
        let newButtonItem = UIBarButtonItem(title: "", image: imageForMenu, primaryAction: nil, menu: sortMenu)
        navigationItem.rightBarButtonItem = newButtonItem
        
        fillTable()
        
        //get data
        DispatchQueue.global(qos: .userInitiated).async {
            APIManager.shared.getAllPosts { posts in
                self.posts = posts
                self.postsTruncatedValues = Array(repeating: .truncated, count: posts.count)
                //reload data in table
                DispatchQueue.main.async {
                    self.loadingLabel.isHidden = true
                    self.postsTable.isHidden = false
                    self.postsTable.reloadData()
                }
            } onError: { message in
                DispatchQueue.main.async {
                    self.showError(message: message)
                }
            }
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
            cell.initData(posts[indexPath.row], isTruncated: postsTruncatedValues[indexPath.row]) {
                self.postsTruncatedValues[indexPath.row].toggle()
                self.postsTable.reloadData()
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
