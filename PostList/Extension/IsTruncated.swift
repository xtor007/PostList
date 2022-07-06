//
//  IsTruncated.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 06.07.2022.
//

import UIKit

extension UILabel {

    //is the line truncated?
    func isTruncated() -> Bool {
        guard let labelText = text else {
            return false
        }
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size
        print(labelTextSize.height)
        print(bounds.size.height)
        print(frame.height)
        return labelTextSize.height > bounds.size.height
    }
    
}
