//
//  Mediable.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - Mediable protocol

protocol Mediable {
    var id: String? { get }
}

// MARK: - Media's mediable implementation

extension Media: Mediable {}
