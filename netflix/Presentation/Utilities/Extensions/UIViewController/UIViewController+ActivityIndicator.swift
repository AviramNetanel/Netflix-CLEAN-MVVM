//
//  UIViewController+ActivityIndicator.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

extension UITableViewController {
    func createActivityIndicator(of size: CGSize) -> UIActivityIndicatorView {
        let style: UIActivityIndicatorView.Style
        
        if #available(iOS 12, *) {
            if traitCollection.userInterfaceStyle == .dark {
                style = .medium
            } else {
                style = .medium
            }
        } else {
            style = .gray
        }
        
        let activityIndicator = UIActivityIndicatorView(style: style)
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        activityIndicator.frame = .init(origin: .zero, size: size)
        return activityIndicator
    }
}
