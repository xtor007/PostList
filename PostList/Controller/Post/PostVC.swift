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
    
    var spinner: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post"
        
        //add back button
        let backButton = UIBarButtonItem(title: "Back", image: UIImage(systemName: "chevron.backward"), primaryAction: UIAction(handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }), menu: nil)
        navigationItem.leftBarButtonItem = backButton
        
        showLoading(onView: postImage)
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
                
                //load photo
                APIManager.shared.getPhoto(byLink: post.postImage) { image in
                    DispatchQueue.main.async {
                        self?.postImage.image = image
                        self?.spinner?.removeFromSuperview()
                        self?.spinner = nil
                    }
                } onError: { message in
                    DispatchQueue.main.async {
                        self?.showError(message: message)
                    }
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
    
    //add spinner
    private func showLoading(onView view: UIView) {
        let spinnerView = UIView(frame: view.bounds)
        spinnerView.backgroundColor = .gray
        spinnerView.backgroundColor = spinnerView.backgroundColor?.withAlphaComponent(0.1)
        let ai = UIActivityIndicatorView(style: .medium)
        ai.startAnimating()
        ai.center = spinnerView.center
        spinnerView.addSubview(ai)
        view.addSubview(spinnerView)
        spinner = spinnerView
    }
    
}
