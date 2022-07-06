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
    
    private let expandButtonHeight: CGFloat = 30
    @IBOutlet weak var expandButtonConstraintHeight: NSLayoutConstraint!
    
    private let currentDate = Date(timeIntervalSinceNow: 0)
    
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
    
    func initData(_ data: PostInFeed) {
        nameLabel.text = data.title
        descriptionLabel.text = data.preview_text
        likesLabel.text = "❤️\(data.likes_count)"
        let postDate = Date(timeIntervalSince1970: data.timeshamp)
        let daysAgoCount = Int(postDate.distance(to: currentDate)/3600/24) //3600 seconds in hour && 24 hours in day
        var timeDescription = "days ago"
        if daysAgoCount % 10 == 1 {
            timeDescription = "day ago"
        }
        timeLabel.text = "\(daysAgoCount) \(timeDescription)"
    }
    
    @IBAction func expandAction(_ sender: Any) {
    }
    
}
