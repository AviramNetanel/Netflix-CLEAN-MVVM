//
//  ViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    associatedtype CoordinatorType: Coordinate
    
    var coordinator: CoordinatorType? { get set }
    
    func transform(input: Input) -> Output
}
