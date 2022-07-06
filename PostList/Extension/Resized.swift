//
//  Resized.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 07.07.2022.
//

import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
