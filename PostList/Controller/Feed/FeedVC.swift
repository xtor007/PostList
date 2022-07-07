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
    
    private var sortParameter = SortType.none
    
    private var sortMenu: UIMenu {
        return UIMenu(title: "firstly show", image: nil, identifier: nil, options: [], children: [
            UIAction(title: "Popular", image: nil, handler: { (_) in
                self.sort(by: .likes)
                self.postsTable.reloadData()
            }),
            UIAction(title: "New", image: nil, handler: { (_) in
                self.sort()
                self.postsTable.reloadData()
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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            APIManager.shared.getAllPosts { posts in
                self?.posts = posts
                self?.postsTruncatedValues = Array(repeating: .truncated, count: posts.count)
                
                //reload data in table
                DispatchQueue.main.async {
                    self?.loadingLabel.isHidden = true
                    self?.postsTable.isHidden = false
                    self?.postsTable.reloadData()
                }
            } onError: { message in
                DispatchQueue.main.async {
                    self?.showError(message: message)
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
    
    //sort function
    private func sort(by sortType: SortType = .date) {
        if sortType == .date {
            posts = posts.sorted { firstPost, secondPost in
                return firstPost.timeshamp > secondPost.timeshamp
            }
        } else {
            posts = posts.sorted { firstPost, secondPost in
                return firstPost.likes_count > secondPost.likes_count
            }
        }
        postsTruncatedValues = Array(repeating: .truncated, count: posts.count)
    }
    
    enum SortType {
        case date, likes, none
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let postVC = PostVC(id: posts[indexPath.row].postId)
        self.navigationController?.pushViewController(postVC, animated: true)
    }
    
}
