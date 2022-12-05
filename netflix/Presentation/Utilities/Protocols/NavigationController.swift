//
//  NavigationController.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit.UINavigationController

// MARK: - NavigationController class

final class NavigationController: UINavigationController {
    
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

