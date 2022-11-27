//
//  CategoriesOverlayViewDIProvider.swift
//  netflix
//
//  Created by Zach Bazov on 25/11/2022.
//

import UIKit.UITableView

// MARK: - CategoriesOverlayViewDIProvider class

final class CategoriesOverlayViewDIProvider {
    
    struct Dependencies {
        weak var tableView: UITableView!
        weak var viewModel: CategoriesOverlayViewViewModel!
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - CategoriesOverlayViewDependencies implementation

extension CategoriesOverlayViewDIProvider: CategoriesOverlayViewDependencies {
    
    func createCategoriesOverlayViewTableViewCell(using provider: CategoriesOverlayViewDIProvider,
                                                  for indexPath: IndexPath) -> CategoriesOverlayViewTableViewCell {
        return CategoriesOverlayViewTableViewCell.create(on: provider.dependencies.tableView,
                                                         for: indexPath,
                                                         with: provider.dependencies.viewModel.items.value)
    }
}
