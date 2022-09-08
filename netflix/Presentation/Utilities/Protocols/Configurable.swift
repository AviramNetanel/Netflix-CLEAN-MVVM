//
//  Configurable.swift
//  netflix
//
//  Created by Zach Bazov on 08/09/2022.
//

import UIKit

// MARK: - Configurable protocol

protocol Configurable {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

// MARK: - Default implementation

extension Configurable {
    static var reuseIdentifier: String {
        return .init(describing: Self.self)
    }
    static var nib: UINib {
        return .init(nibName: reuseIdentifier, bundle: nil)
    }
}
