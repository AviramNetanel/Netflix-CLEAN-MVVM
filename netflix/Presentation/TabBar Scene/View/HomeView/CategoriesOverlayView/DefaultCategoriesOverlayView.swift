//
//  DefaultCategoriesOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewInput protocol

private protocol CategoriesOverlayViewInput {
    var tableView: UITableView! { get }
}

// MARK: - CategoriesOverlayViewOutput protocol

private protocol CategoriesOverlayViewOutput {}

// MARK: - CategoriesOverlayView protocol

private protocol CategoriesOverlayView: CategoriesOverlayViewInput, CategoriesOverlayViewOutput {}

// MARK: - DefaultCategoriesOverlayView class

final class DefaultCategoriesOverlayView: UIView, CategoriesOverlayView, ViewInstantiable {
    
    enum Category: Int {
        case home
        case myList
        case action
        case sciFi
        case crime
        case thriller
        case adventure
        case comedy
        case horror
        case anime
        case familyNchildren
        case documentary
    }
    
    @IBOutlet private(set) weak var opaqueView: DefaultOpaqueView!
    
    fileprivate var tableView: UITableView!
    
    private(set) var viewModel = DefaultCategoriesOverlayViewViewModel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibDidLoad()
        self.setupBindings()
        self.viewModel.viewDidLoad()
    }
    
    deinit { tableView = nil }
    
    private func setupBindings() {
        isPresented(in: viewModel)
    }
    
    private func isPresented(in viewModel: DefaultCategoriesOverlayViewViewModel) {
        viewModel.isPresented.observe(on: self) { [weak self] _ in self?.setupDataSource() }
    }
    
    private func setupDataSource() {
        if case true = viewModel.isPresented.value { return isHidden(false) }
        isHidden(true)
    }
    
    func removeObservers() {
        printIfDebug("Removed `DefaultCategoriesOverlayView` observers.")
        viewModel.isPresented.remove(observer: self)
    }
}

// MARK: - Valuable implementation

extension DefaultCategoriesOverlayView.Category: Valuable {
    
    var stringValue: String {
        switch self {
        case .home: return "Home"
        case .myList: return "My List"
        case .action: return "Action"
        case .sciFi: return "Sci-Fi"
        case .crime: return "Crime"
        case .thriller: return "Thriller"
        case .adventure: return "Adventure"
        case .comedy: return "Comedy"
        case .horror: return "Horror"
        case .anime: return "Anime"
        case .familyNchildren: return "Family & Children"
        case .documentary: return "Documentary"
        }
    }
}
