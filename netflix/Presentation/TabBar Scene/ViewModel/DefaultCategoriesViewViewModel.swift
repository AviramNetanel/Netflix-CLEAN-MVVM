//
//  DefaultCategoriesViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - CategoriesOverlayViewViewModelInput protocol

private protocol CategoriesOverlayViewViewModelInput {
    var isPresented: Observable<Bool> { get }
}

// MARK: - CategoriesOverlayViewViewModelOutput protocol

private protocol CategoriesOverlayViewViewModelOutput {
    func viewDidLoad()
}

// MARK: - CategoriesOverlayViewViewModel protocol

private protocol CategoriesOverlayViewViewModel: CategoriesOverlayViewViewModelInput,
                                                 CategoriesOverlayViewViewModelOutput {}

// MARK: - DefaultCategoriesOverlayViewViewModel class

final class DefaultCategoriesOverlayViewViewModel: CategoriesOverlayViewViewModel {
    
    var isPresented: Observable<Bool> = Observable(false)
    
    func viewDidLoad() {
        isPresented.value = false
    }
}
