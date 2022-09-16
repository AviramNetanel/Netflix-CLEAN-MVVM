//
//  UITableView+Register.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import UIKit

// MARK: - UITableView + Register

extension UITableView {
    
    func register<T: UITableViewHeaderFooterView>(headerFooter type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: type.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(class type: T.Type) {
        register(type, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func register<T: UITableViewCell>(nib type: T.Type) {
        register(type.nib, forCellReuseIdentifier: type.reuseIdentifier)
    }
    
    func register(_ identifiers: [String]) {
        for identifier in identifiers {
            register(.init(nibName: identifier, bundle: nil),
                    forCellReuseIdentifier: identifier)
        }
    }
}
