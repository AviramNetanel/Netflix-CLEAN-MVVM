//
//  UITableView+DequeueReusableCell.swift
//  netflix
//
//  Created by Zach Bazov on 09/09/2022.
//

import UIKit

// MARK: - UITableView + DequeueReusableCell

extension UITableView {
    func dequeueReusableCell<T>(ofType type: T.Type, at indexPath: IndexPath) -> T where T: Configurable {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cannot dequeue reusable cell \(T.self) with reuseIdentifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
