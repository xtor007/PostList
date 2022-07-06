//
//  PostInFeed.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 06.07.2022.
//

import Foundation

struct PostInFeed: Decodable {
    var postId: Int
    var timeshamp: TimeInterval
    var title: String
    var preview_text: String
    var likes_count: Int
}

struct PostInFeedData: Decodable {
    var posts: [PostInFeed]
}
