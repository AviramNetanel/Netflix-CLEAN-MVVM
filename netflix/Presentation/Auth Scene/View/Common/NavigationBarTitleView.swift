//
//  NavigationBarTitleView.swift
//  netflix
//
//  Created by Zach Bazov on 05/09/2022.
//

import UIKit

// MARK: - NavigationBarTitleView class

final class NavigationBarTitleView: UINavigationItem {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 20))
        imageView.image = UIImage(named: "netflix-logo-2")
        imageView.contentMode = .scaleAspectFit
        titleView = imageView
    }
}
