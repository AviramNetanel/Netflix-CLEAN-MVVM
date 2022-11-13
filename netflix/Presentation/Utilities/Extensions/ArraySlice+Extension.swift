//
//  ArraySlice+Extension.swift
//  netflix
//
//  Created by Zach Bazov on 31/10/2022.
//

import Foundation

// MARK: - ArraySlice extension

extension ArraySlice where Element == NavigationView.State {
    func toArray() -> [Element] { Array(self) }
}
