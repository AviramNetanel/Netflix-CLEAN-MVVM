//
//  UIViewController+SceneDelegate.swift
//  netflix
//
//  Created by Zach Bazov on 06/09/2022.
//

import UIKit

// MARK: - UIViewController + SceneDelegate

extension UIViewController {
    var sceneDelegate: SceneDelegate? {
        return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    }
}
