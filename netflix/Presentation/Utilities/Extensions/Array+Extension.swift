//
//  Array+Extension.swift
//  netflix
//
//  Created by Zach Bazov on 18/10/2022.
//

import Foundation

extension Array where Element == Media {
    func slice(_ maxLength: Int) -> [Element] { Array(prefix(maxLength)) }
    func toObjectIDs() -> [String] { map { String($0.id!) } }
    func toSet() -> Set<Element> { Set(self) }
}
