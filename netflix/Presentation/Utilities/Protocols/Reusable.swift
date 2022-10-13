//
//  Reusable.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import Foundation

// MARK: - Reusable protocol

protocol Reusable {}

// MARK: - Default implementation

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
