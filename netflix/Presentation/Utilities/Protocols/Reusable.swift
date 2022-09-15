//
//  Reusable.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - Reusable protocol

public protocol Reusable {}

// MARK: - Reusable implementation

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
