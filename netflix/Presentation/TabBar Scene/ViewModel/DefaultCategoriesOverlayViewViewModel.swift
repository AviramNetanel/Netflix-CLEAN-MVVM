//
//  DefaultCategoriesOverlayViewViewModel.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import Foundation

// MARK: - CategoriesOverlayViewViewModelInput protocol

private protocol CategoriesOverlayViewViewModelInput {
    func viewDidLoad()
}

// MARK: - CategoriesOverlayViewViewModelOutput protocol

private protocol CategoriesOverlayViewViewModelOutput {
    var isPresented: Observable<Bool> { get }
    var categoriesDidTap: (() -> Void)? { get }
}

// MARK: - CategoriesOverlayViewViewModel protocol

private protocol CategoriesOverlayViewViewModel: CategoriesOverlayViewViewModelInput,
                                                 CategoriesOverlayViewViewModelOutput {}

// MARK: - DefaultCategoriesOverlayViewViewModel class

final class DefaultCategoriesOverlayViewViewModel: CategoriesOverlayViewViewModel {
    
    var isPresented: Observable<Bool> = Observable(false)
    
    var categoriesDidTap: (() -> Void)?
    
    func viewDidLoad() {}
}
