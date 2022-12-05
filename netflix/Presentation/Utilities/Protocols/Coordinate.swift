//
//  Coordinate.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit.UIViewController

// MARK: - Coordinate protocol

protocol Coordinate {
    
    associatedtype Screen
    associatedtype View: UIViewController
    
    var viewController: View? { get set }
    
    func showScreen(_ screen: Screen)
}
