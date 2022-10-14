//
//  NavigationBarTitleView.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - NavigationBarTitleView class

final class NavigationBarTitleView: UINavigationItem {
    
    private let imageView: UIImageView = {
        let resourceName = "netflix-logo-2"
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 20))
        imageView.image = UIImage(named: resourceName)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.titleView = imageView
    }
}
