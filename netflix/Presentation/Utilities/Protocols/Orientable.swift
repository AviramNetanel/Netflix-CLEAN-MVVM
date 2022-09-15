//
//  Orientable.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - Orientable protocol

protocol Orientable {
    static var orientation: UIInterfaceOrientationMask { get set }
}
