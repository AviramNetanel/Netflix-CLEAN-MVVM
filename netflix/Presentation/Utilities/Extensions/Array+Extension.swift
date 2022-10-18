//
//  Array+Extension.swift
//  netflix
//
//  Created by Zach Bazov on 18/10/2022.
//

import Foundation

// MARK: - Array extension

extension Array where Element == Media {
    func slice(_ maxLength: Int) -> Array<Element> {
        let slice = prefix(maxLength)
        return Array(slice)
    }
}
