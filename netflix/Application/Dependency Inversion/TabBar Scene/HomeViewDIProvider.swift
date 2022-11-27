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
    private(set) var categoriesOverlayViewDependencies: CategoriesOverlayViewDIProvider!
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func createCategoriesOverlayViewDIProvider(using tableView: UITableView,
                                               viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewDIProvider {
        let dependencies = CategoriesOverlayViewDIProvider.Dependencies(tableView: tableView, viewModel: viewModel)
        return CategoriesOverlayViewDIProvider(dependencies: dependencies)
    }
}

// MARK: - HomeTableViewDataSourceDependencies implmenetation

extension HomeViewDIProvider: HomeTableViewDataSourceDependencies {
    
    func createHomeTableViewDataSourceActions() -> HomeTableViewDataSourceActions {
        return HomeTableViewDataSourceActions(heightForRowAt: dependencies.homeViewController.heightForRow(at:),
                                              viewDidScroll: dependencies.homeViewController.viewDidScroll(in:),
                                              didSelectItem: dependencies.homeViewController.didSelectItem(at:of:))
    }
    
    func createDisplayTableViewCell(for indexPath: IndexPath) -> DisplayTableViewCell {
        return .create(using: self, for: indexPath)
    }
    
    func createRatableTableViewCell(for indexPath: IndexPath,
                                    with actions: CollectionViewDataSourceActions) -> RatableTableViewCell {
        return RatableTableViewCell.create(using: self, for: indexPath, with: actions)! as! RatableTableViewCell
    }
    
    func createResumableTableViewCell(for indexPath: IndexPath,
                                      with actions: CollectionViewDataSourceActions) -> ResumableTableViewCell {
        return ResumableTableViewCell.create(using: self, for: indexPath, with: actions)! as! ResumableTableViewCell
    }
    
    func createStandardTableViewCell(for indexPath: IndexPath,
                                     with actions: CollectionViewDataSourceActions) -> StandardTableViewCell {
        return StandardTableViewCell.create(using: self, for: indexPath, with: actions)
    }
    
    func createTableViewHeaderFooterView(at section: Int) -> TableViewHeaderFooterView {
        return .create(using: self, for: section)!
    }
}

// MARK: - DisplayTableViewCellDependencies implementation

extension HomeViewDIProvider: DisplayTableViewCellDependencies {
    
    func createDisplayTableViewCellViewModel() -> DisplayTableViewCellViewModel {
        return DisplayTableViewCellViewModel(
            presentedDisplayMedia: dependencies.homeViewModel.presentedDisplayMedia,
            presentedDisplayMediaDidChange: dependencies.homeViewModel.presentedDisplayMediaDidChange,
            myList: dependencies.homeViewModel.myList,
            sectionAt: dependencies.homeViewModel.section(at:),
            actions: dependencies.homeViewModel.dependencies.actions)
    }
}

// MARK: - DisplayViewDependencies implementation

extension HomeViewDIProvider: DisplayViewDependencies {
    
    func createDisplayView(with viewModel: DisplayTableViewCellViewModel) -> DisplayView {
        return .create(with: viewModel, homeSceneDependencies: self)
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
        return .create(on: view.panelViewContainer, viewModel: viewModel, homeSceneDependencies: self)
    }
    
    func createPanelViewItems(on view: PanelView,
                              with viewModel: DisplayTableViewCellViewModel) {
        view.leadingItemView = .create(on: view.leadingItemViewContainer, viewModel: viewModel, homeSceneDependencies: self)
        view.trailingItemView = .create(on: view.trailingItemViewContainer, viewModel: viewModel, homeSceneDependencies: self)
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

// MARK: - MyListDependencies implementation

extension HomeViewDIProvider: MyListDependencies {
    
    func createMyListActions() -> MyListActions {
        return MyListActions(
            listDidReload: { [weak self] in
                guard
                    let self = self,
                    self.dependencies.homeViewController.tableView.numberOfSections > 0,
                    let myListIndex = HomeTableViewDataSource.Index(rawValue: 6)
                else { return }
                let section = self.dependencies.homeViewModel.section(at: .myList)
                self.dependencies.homeViewModel.filter(section: section)
                let index = IndexSet(integer: myListIndex.rawValue)
                self.dependencies.homeViewController.tableView.reloadSections(index, with: .automatic)
            })
    }
}

// MARK: - NavigationViewDependencies implementation

extension HomeViewDIProvider: NavigationViewDependencies {
    
    func createNavigationView(on view: UIView) -> NavigationView {
        return .create(onParent: view, homeSceneDependencies: self)
    }
    
    func createNavigationViewViewModel(with items: [NavigationViewItem]) -> NavigationViewViewModel {
        return NavigationViewViewModel(items: items, actions: createNavigationViewViewModelActions())
    }
    
    func createNavigationViewItems(on navigationView: NavigationView) -> [NavigationViewItem] {
        navigationView.homeItemView = NavigationViewItem(onParent: navigationView.homeItemViewContainer)
        navigationView.airPlayItemView = NavigationViewItem(onParent: navigationView.airPlayItemViewContainer)
        navigationView.accountItemView = NavigationViewItem(onParent: navigationView.accountItemViewContainer)
        navigationView.tvShowsItemView = NavigationViewItem(onParent: navigationView.tvShowsItemViewContainer)
        navigationView.moviesItemView = NavigationViewItem(onParent: navigationView.moviesItemViewContainer)
        navigationView.categoriesItemView = NavigationViewItem(onParent: navigationView.categoriesItemViewContainer)
        return [navigationView.homeItemView, navigationView.airPlayItemView, navigationView.accountItemView,
                navigationView.tvShowsItemView, navigationView.moviesItemView, navigationView.categoriesItemView]
    }
    
    func createNavigationViewViewModelActions() -> NavigationViewViewModelActions {
        return NavigationViewViewModelActions(
            stateDidChangeOnViewModel: { homeViewController, state in
                homeViewController.navigationView?.viewModel.actions.stateDidChangeOnViewController(homeViewController, state)
                
                homeViewController.navigationView?.categoriesItemView.viewDidConfigure(with: state)

                switch state {
                case .home:
                    homeViewController.navigationView?.tvShowsItemViewContainer.isHidden(false)
                    homeViewController.navigationView?.moviesItemViewContainer.isHidden(false)
                    homeViewController.navigationView?.categoriesItemViewContainer.isHidden(false)
                    homeViewController.navigationView?.itemsCenterXConstraint.constant = .zero

                    homeViewController.navigationView?.tvShowsItemView.viewModel.hasInteracted = false
                    homeViewController.navigationView?.moviesItemView.viewModel.hasInteracted = false
                case .airPlay:
                    break
                case .account:
                    break
                case .tvShows:
                    homeViewController.navigationView?.tvShowsItemViewContainer.isHidden(false)
                    homeViewController.navigationView?.moviesItemViewContainer.isHidden(true)
                    homeViewController.navigationView?.categoriesItemViewContainer.isHidden(false)
                    homeViewController.navigationView?.itemsCenterXConstraint.constant = -24.0

                    homeViewController.navigationView?.tvShowsItemView.viewModel.hasInteracted = true
                case .movies:
                    homeViewController.navigationView?.tvShowsItemViewContainer.isHidden(true)
                    homeViewController.navigationView?.moviesItemViewContainer.isHidden(false)
                    homeViewController.navigationView?.categoriesItemViewContainer.isHidden(false)
                    homeViewController.navigationView?.itemsCenterXConstraint.constant = -32.0
                    
                    homeViewController.navigationView?.moviesItemView.viewModel.hasInteracted = true
                case .categories:
                    break
                }
                
                homeViewController.navigationView?.animateUsingSpring(withDuration: 0.33, withDamping: 0.7, initialSpringVelocity: 0.7)
            }, stateDidChangeOnViewController: { homeViewController, state in
                homeViewController.categoriesOverlayView.viewModel.navigationViewState = state
                
                switch state {
                case .home:
                    guard homeViewController.viewModel.tableViewState.value != .all else {
                        guard homeViewController.navigationView.homeItemView.viewModel.hasInteracted else {
                            return homeViewController.categoriesOverlayView.viewModel.isPresented.value = false
                        }
                        return homeViewController.categoriesOverlayView.viewModel.isPresented.value = true
                    }

                    homeViewController.viewModel.tableViewState.value = .all
                    homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
                case .tvShows:
                    guard homeViewController.viewModel.tableViewState.value != .series else {
                        guard homeViewController.navigationView.tvShowsItemView.viewModel.hasInteracted else {
                            return homeViewController.categoriesOverlayView.viewModel.isPresented.value = false
                        }
                        return homeViewController.categoriesOverlayView.viewModel.isPresented.value = true
                    }

                    homeViewController.viewModel.tableViewState.value = .series
                    homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
                case .movies:
                    guard homeViewController.viewModel.tableViewState.value != .films else {
                        guard homeViewController.navigationView.moviesItemView.viewModel.hasInteracted else {
                            return homeViewController.categoriesOverlayView.viewModel.isPresented.value = false
                        }
                        return homeViewController.categoriesOverlayView.viewModel.isPresented.value = true
                    }

                    homeViewController.viewModel.tableViewState.value = .films
                    homeViewController.categoriesOverlayView.viewModel.state = .mainMenu
                case .categories:
                    homeViewController.categoriesOverlayView.viewModel.isPresented.value = true
                    homeViewController.categoriesOverlayView.viewModel.state = .categories
                default: return
                }
            })
    }
}
