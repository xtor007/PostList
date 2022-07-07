//
//  APIManager.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 06.07.2022.
//

import UIKit

class APIManager {
    
    static let shared = APIManager()
    
    private let serverLink = "https://raw.githubusercontent.com/anton-natife/jsons/master/api/"
    private let feedLink = "main"
    private let postLink = "posts/"
    private let jsonString = ".json"
    
    private let session = URLSession(configuration: .default)
    
    private init() {}
    
    //function to get data into the feed
    func getAllPosts(onSuccess: @escaping ([PostInFeed])->(Void), onError: @escaping (String)->(Void)) {
        guard let url = URL(string: "\(serverLink)\(feedLink)\(jsonString)") else {
            onError("Failed link")
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                onError("Invalid data or response")
                return
            }
            do {
                if response.statusCode == 200 {
                    let result = try JSONDecoder().decode(PostInFeedData.self, from: data)
                    onSuccess(result.posts)
                } else {
                    let err = try JSONDecoder().decode(String.self, from: data)
                    onError("Server return error: \(err)")
                }
            }
            catch {
                onError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    //function to get post by id
    func getPost(byId id: Int, onSuccess: @escaping (Post)->(Void), onError: @escaping (String)->(Void)) {
        guard let url = URL(string: "\(serverLink)\(postLink)\(id)\(jsonString)") else {
            onError("Failed link")
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                onError("Invalid data or response")
                return
            }
            do {
                if response.statusCode == 200 {
                    let result = try JSONDecoder().decode(PostData.self, from: data)
                    onSuccess(result.post)
                } else {
                    let err = try JSONDecoder().decode(String.self, from: data)
                    onError("Server return error: \(err)")
                }
            }
            catch {
                onError(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    //function to get photo
    func getPhoto(byLink link: String, onSuccess: @escaping (UIImage)->(Void), onError: @escaping (String)->(Void)) {
        guard let url = URL(string: link) else {
            onError("Failed link")
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            guard let data = data, let response = response as? HTTPURLResponse else {
                onError("Invalid data or response")
                return
            }
            if response.statusCode == 200 {
                if let image = UIImage(data: data) {
                    onSuccess(image)
                } else {
                    onError("It isn't photo link")
                }
            } else {
                onError("Server return error")
            }
        }
        task.resume()
    }
    
}
