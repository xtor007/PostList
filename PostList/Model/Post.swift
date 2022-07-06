//
//  Post.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 07.07.2022.
//

import Foundation

struct Post: Decodable {
    var postId: Int
    var timeshamp: TimeInterval
    var title: String
    var text: String
    var postImage: String
    var likes_count: Int
}

struct PostData: Decodable {
    var post: Post
}
