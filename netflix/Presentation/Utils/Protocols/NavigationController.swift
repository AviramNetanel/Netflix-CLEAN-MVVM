//
//  NavigationController.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit.UINavigationController

class NavigationController: UINavigationController {
    weak var progress: UIProgressView!
    
    var isProgressHidden: Bool = true {
        didSet {
            setupProgress()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        navigationBar.prefersLargeTitles = false
        navigationBar.barStyle = .black
        navigationBar.tintColor = .white
    }

    private func setupProgress() {
        if isProgressHidden {
            if progress != nil {
                progress.removeFromSuperview()
                updateViewConstraints()
            }
        } else {
            let progress = UIProgressView(progressViewStyle: .bar)
            progress.translatesAutoresizingMaskIntoConstraints = false
            progress.progress = 0
            progress.backgroundColor = .black
            navigationBar.addSubview(progress)
            NSLayoutConstraint.activate([
                progress.heightAnchor.constraint(equalToConstant: 5),
                progress.leftAnchor.constraint(equalTo: navigationBar.leftAnchor),
                progress.rightAnchor.constraint(equalTo: navigationBar.rightAnchor),
                progress.topAnchor.constraint(equalTo: navigationBar.bottomAnchor)
                ])
            self.progress = progress
        }
    }
}

extension UIViewController {
    func addNavigationItemTitleView() {
        let asset = "netflix-logo-2"
        
        let point = CGPoint(x: 0.0, y: 0.0)
        let size = CGSize(width: 80.0, height: 24.0)
        let rect = CGRect(origin: point, size: size)
        
        let titleView = UIView(frame: rect)
        let image = UIImage(named: asset)
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        imageView.center = CGPoint(x: titleView.center.x, y: titleView.center.y)
        
        titleView.addSubview(imageView)
        navigationItem.titleView = titleView
    }
}
