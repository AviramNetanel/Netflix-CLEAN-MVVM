//
//  Set+Extension.swift
//  netflix
//
//  Created by Zach Bazov on 15/11/2022.
//

import Foundation

// MARK: - Set extension

extension Set where Element == Media {
    func toArray() -> [Element] { Array(self) }
}
