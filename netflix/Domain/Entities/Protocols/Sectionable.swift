//
//  Sectionable.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import Foundation

protocol Sectionable {
    var id: Int { get }
    var title: String { get }
}

extension Section: Sectionable {}
