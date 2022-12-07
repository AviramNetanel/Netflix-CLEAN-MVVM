//
//  Mediable.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

protocol Mediable {
    var id: String? { get }
}

extension Media: Mediable {}
