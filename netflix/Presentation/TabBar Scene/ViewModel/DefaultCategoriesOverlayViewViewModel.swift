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
    
    var state: DefaultNavigationView.State { get }
    var category: DefaultCategoriesOverlayView.Category { get }
}

// MARK: - CategoriesOverlayViewViewModel protocol

private protocol CategoriesOverlayViewViewModel: CategoriesOverlayViewViewModelInput,
                                                 CategoriesOverlayViewViewModelOutput {}

// MARK: - DefaultCategoriesOverlayViewViewModel class

final class DefaultCategoriesOverlayViewViewModel: CategoriesOverlayViewViewModel {
    
    var isPresented: Observable<Bool> = Observable(false)
    
    var state: DefaultNavigationView.State = .tvShows
    
    var category: DefaultCategoriesOverlayView.Category = .home
    
    var dataSource: DefaultCategoriesOverlayViewTableViewDataSource!
    
    func viewDidLoad() {
        dataSource = DefaultCategoriesOverlayViewTableViewDataSource(items: [], with: self)
    }
}
