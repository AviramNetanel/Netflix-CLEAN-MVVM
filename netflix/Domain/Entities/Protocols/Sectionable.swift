//
//  Sectionable.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

// MARK: - Sectionable protocol

protocol Sectionable {
    var id: Int { get }
    var title: String { get }
}

// MARK: - Section: Sectionable implementation

extension Section: Sectionable {}
