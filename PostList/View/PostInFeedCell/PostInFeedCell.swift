//
//  PostInFeedCell.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 06.07.2022.
//

import UIKit

class PostInFeedCell: UITableViewCell {
    
    static let nibName = "PostInFeedCell"
    static let cellId = "PostInFeedCellId"
    
    static var isCellNeedExpand = Set<Int>() //collection for not checking the size many times
    
    private let expandButtonHeight: CGFloat = 30
    @IBOutlet weak var expandButtonConstraintHeight: NSLayoutConstraint!
    
    private let currentDate = Date(timeIntervalSinceNow: 0)
    
    private var onExpand: (()->(Void))!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initData(_ data: PostInFeed, isTruncated: TrancatedValue, onExpand: @escaping ()->(Void)) {
        self.onExpand = onExpand
        nameLabel.text = data.title
        
        //set normal data before if
        descriptionLabel.numberOfLines = 2
        expandButtonConstraintHeight.constant = 0
        expandButton.setTitle("Expand", for: .normal)
        
        descriptionLabel.text = data.preview_text
        if isTruncated == .full {
            descriptionLabel.numberOfLines = 0
            expandButton.setTitle("Collapse", for: .normal)
            expandButtonConstraintHeight.constant = expandButtonHeight
        }
        if descriptionLabel.isTruncated() || PostInFeedCell.isCellNeedExpand.contains(data.postId) {
            PostInFeedCell.isCellNeedExpand.insert(data.postId)
            expandButtonConstraintHeight.constant = expandButtonHeight
        }
        likesLabel.text = "❤️\(data.likes_count)"
        
        //date
        let postDate = Date(timeIntervalSince1970: data.timeshamp)
        let daysAgoCount = Int(postDate.distance(to: currentDate)/3600/24) //3600 seconds in hour && 24 hours in day
        var timeDescription = "days ago"
        if daysAgoCount % 10 == 1 {
            timeDescription = "day ago"
        }
        timeLabel.text = "\(daysAgoCount) \(timeDescription)"
    }
    
    @IBAction func expandAction(_ sender: Any) {
        onExpand()
    }
    
}

//enum for check trancated or not trancated description
enum TrancatedValue {
    
    case truncated
    case full
    
    mutating func toggle() {
        if case .truncated = self {
            self = .full
        } else {
            self = .truncated
        }
    }
    
}
