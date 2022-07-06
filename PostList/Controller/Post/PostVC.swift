//
//  PostVC.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 07.07.2022.
//

import UIKit

class PostVC: UIViewController {
    
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var postId: Int
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            APIManager.shared.getPost(byId: self!.postId) { post in
                self?.post = post
                let date = Date(timeIntervalSince1970: post.timeshamp)
                DispatchQueue.main.async {
                    self?.title = post.title
                    self?.nameLabel.text = post.title
                    self?.descriptionLabel.text = post.text
                    self?.likesLabel.text = "❤️\(post.likes_count)"
                    self?.dateLabel.text = date.formatted(date: .long, time: .omitted)
                }
            } onError: { message in
                DispatchQueue.main.async {
                    self?.showError(message: message)
                }
            }
        }
    }
    
    init(id: Int) {
        postId = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
