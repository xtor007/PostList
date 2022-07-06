//
//  ShowError.swift
//  PostList
//
//  Created by Anatoliy Khramchenko on 07.07.2022.
//

import UIKit

extension UIViewController {
    
    func showError(message: String) {
        let alertVC = UIAlertController(
                            title: "ERROR",
                            message: message,
                            preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertVC.addAction(action)
                self.present(alertVC, animated: true, completion: nil)
    }
    
}
