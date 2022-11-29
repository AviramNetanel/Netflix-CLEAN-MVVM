//
//  HomeViewDIProvider.swift
//  netflix
//
//  Created by Zach Bazov on 21/11/2022.
//

import UIKit.UITableView

// MARK: - HomeViewDIProvider class

final class HomeViewDIProvider {
    
    struct Dependencies {
        weak var homeViewController: HomeViewController!
        weak var homeViewModel: HomeViewModel!
        weak var tableView: UITableView!
    }
    
    let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: - HomeTableViewDataSourceDependencies implmenetation

extension HomeViewDIProvider: HomeTableViewDataSourceDependencies {
    
    func createHomeTableViewDataSource() -> HomeTableViewDataSource {
        return HomeTableViewDataSource(using: self, actions: createHomeTableViewDataSourceActions())
    }
    
    func createHomeTableViewDataSourceActions() -> HomeTableViewDataSourceActions {
        return HomeTableViewDataSourceActions(using: self)
    }
    
    func createHomeDisplayTableViewCell(for indexPath: IndexPath) -> DisplayTableViewCell {
        return DisplayTableViewCell(using: self, for: indexPath)
    }
    
    func createHomeRatedTableViewCell(for indexPath: IndexPath,
                                      with actions: CollectionViewDataSourceActions) -> RatedTableViewCell {
        return RatedTableViewCell(using: self, for: indexPath, actions: actions)
    }
    
    func createHomeResumableTableViewCell(for indexPath: IndexPath,
                                          with actions: CollectionViewDataSourceActions) -> ResumableTableViewCell {
        return ResumableTableViewCell(using: self, for: indexPath, actions: actions)
    }
    
    func createHomeStandardTableViewCell(for indexPath: IndexPath,
                                         with actions: CollectionViewDataSourceActions) -> StandardTableViewCell {
        return StandardTableViewCell(using: self, for: indexPath, actions: actions)
    }
    
    func createHomeTableViewHeaderFooterView(at section: Int) -> TableViewHeaderFooterView {
        return TableViewHeaderFooterView(using: self, for: section)
    }
}

// MARK: - HomeCollectionViewDataSourceDependencies implementation

extension HomeViewDIProvider: CollectionViewDataSourceDepenendencies {
    
    func createHomeCollectionViewDataSourceActions(
        for section: Int,
        using actions: HomeTableViewDataSourceActions) -> CollectionViewDataSourceActions {
            return CollectionViewDataSourceActions(
                didSelectItem: { row in
                    actions.didSelectItem(section, row)
                })
        }
}

// MARK: - DisplayTableViewCellDependencies implementation

extension HomeViewDIProvider: DisplayTableViewCellDependencies {
    
    func createDisplayTableViewCellViewModel() -> DisplayTableViewCellViewModel {
        return DisplayTableViewCellViewModel(using: self)
    }
}

// MARK: - DisplayViewDependencies implementation

extension HomeViewDIProvider: DisplayViewDependencies {
    
    func createDisplayView() -> DisplayView {
        return DisplayView(using: self, with: createDisplayTableViewCellViewModel())
    }

    func createDisplayViewViewModel(with cellViewModel: DisplayTableViewCellViewModel) -> DisplayViewViewModel {
        return DisplayViewViewModel(with: cellViewModel.presentedDisplayMedia.value!)
    }

    func createDisplayViewConfiguration(on view: DisplayView) -> DisplayViewConfiguration {
        return DisplayViewConfiguration(view: view, viewModel: createDisplayViewViewModel(with: createDisplayTableViewCellViewModel()))
    }
}

// MARK: - PanelViewDependencies implementation

extension HomeViewDIProvider: PanelViewDependencies {
    
    func createPanelView(on view: DisplayView,
                         with viewModel: DisplayTableViewCellViewModel) -> PanelView {
        return PanelView(using: self, on: view.panelViewContainer, with: viewModel)
    }
    
    func createPanelViewItemViewModel(on view: PanelViewItem,
                                      with viewModel: DisplayTableViewCellViewModel) -> PanelViewItemViewModel {
        return PanelViewItemViewModel(item: view, with: viewModel.presentedDisplayMedia.value!)
    }
    
    func createPanelViewItemConfiguration(on view: PanelViewItem,
                                          with viewModel: DisplayTableViewCellViewModel) -> PanelViewItemConfiguration {
        return PanelViewItemConfiguration(view: view, gestureRecognizers: [.tap], with: viewModel)
    }
}

// MARK: - CategoriesOverlayViewDependencies implementation

extension HomeViewDIProvider: CategoriesOverlayViewDependencies {
    
    func createCategoriesOverlayView() -> CategoriesOverlayView {
        return CategoriesOverlayView(using: self)
    }
    
    func createCategoriesOverlayViewViewModel() -> CategoriesOverlayViewViewModel {
        return CategoriesOverlayViewViewModel()
    }
    
    func createCategoriesOverlayViewTableViewDataSource(with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewTableViewDataSource {
        return CategoriesOverlayViewTableViewDataSource(using: self, with: viewModel)
    }
    
    func createCategoriesOverlayViewTableViewCell(for indexPath: IndexPath) -> CategoriesOverlayViewTableViewCell {
        return CategoriesOverlayViewTableViewCell(on: dependencies.homeViewController.categoriesOverlayView.tableView,
                                                  for: indexPath,
                                                  with: dependencies.homeViewController.categoriesOverlayView.viewModel.items.value)
    }
    
    func createCategoriesOverlayViewFooterView(on parent: UIView,
                                               with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewFooterView {
        return CategoriesOverlayViewFooterView(parent: parent, viewModel: viewModel)
    }
    
    func createCategoriesOverlayViewOpaqueView() -> OpaqueView {
        return OpaqueView(frame: UIScreen.main.bounds)
    }
}

// MARK: - NavigationViewDependencies implementation

extension HomeViewDIProvider: NavigationViewDependencies {
    
    func createNavigationView() -> NavigationView {
        return NavigationView(using: self, on: dependencies.homeViewController.navigationViewContainer)
    }
    
    func createNavigationViewViewModel(with items: [NavigationViewItem]) -> NavigationViewViewModel {
        return NavigationViewViewModel(items: items, actions: createNavigationViewViewModelActions())
    }
    
    func createNavigationViewViewModelActions() -> NavigationViewViewModelActions {
        return NavigationViewViewModelActions(
            stateDidChangeOnViewModel: { homeViewController, state in
                
                homeViewController.navigationView?.viewModel.actions
                    .stateDidChangeOnViewController(homeViewController, state)
                
                homeViewController.categoriesOverlayView?.viewModel
                    .stateDidChangeOnViewModel(homeViewController: homeViewController, state: state)
                
            }, stateDidChangeOnViewController: { homeViewController, state in
                
                homeViewController.categoriesOverlayView?.viewModel
                    .stateDidChange(homeViewController: homeViewController, state: state)
            })
    }
}

// MARK: - MyListDependencies implementation

extension HomeViewDIProvider: MyListDependencies {
    
    func createMyListActions() -> MyListActions {
        return MyListActions(listDidReload: dependencies.homeViewModel.reloadMyList)
    }
}
