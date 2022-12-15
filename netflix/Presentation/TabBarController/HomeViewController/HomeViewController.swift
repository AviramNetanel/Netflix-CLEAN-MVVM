//
//  HomeViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

final class HomeViewController: UIViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet private(set) var navigationViewContainer: UIView!
    @IBOutlet private(set) var navigationViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private(set) var browseOverlayViewContainer: UIView!
    @IBOutlet private(set) var browseOverlayBottomConstraint: NSLayoutConstraint!
    
    var viewModel: HomeViewModel!
    var navigationView: NavigationView!
    var categoriesOverlayView: NavigationOverlayView!
    var browseOverlayView: BrowseOverlayView!
    var dataSource: HomeTableViewDataSource!
    
    deinit {
        browseOverlayView = nil
        categoriesOverlayView = nil
        navigationView = nil
        dataSource = nil
        viewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupSubviews()
        setupObservers()
        viewModel.viewWillLoad()
    }
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func setupSubviews() {
        setupDataSource()
        setupNavigationView()
        setupCategoriesOverlayView()
        setupBrowseOverlayView()
    }
    
    private func setupObservers() {
        tableViewState(in: viewModel)
        presentedDisplayMedia(in: viewModel)
    }
    
    func removeCoordinator() {
        viewModel?.coordinator = nil
    }
    
    func setupDataSource() {
        /// Filters the sections based on the data source state.
        viewModel.filter(sections: viewModel.sections)
        /// Initializes the data source.
        dataSource = HomeTableViewDataSource(tableView: tableView, viewModel: viewModel)
    }
    
    func setupNavigationView() {
        navigationView = NavigationView(on: navigationViewContainer, with: viewModel)
    }
    
    private func setupCategoriesOverlayView() {
        categoriesOverlayView = NavigationOverlayView(with: viewModel)
    }
    
    private func setupBrowseOverlayView() {
        browseOverlayView = BrowseOverlayView(on: browseOverlayViewContainer, with: viewModel)
        browseOverlayViewContainer.isHidden(true)
    }
    
    func removeObservers() {
        if let viewModel = viewModel {
            printIfDebug("Removed `HomeViewModel` observers.")
            Application.current.coordinator.coordinator.tableViewState.remove(observer: self)
            viewModel.presentedDisplayMedia.remove(observer: self)
        }
    }
}

extension HomeViewController {
    func heightForRow(at indexPath: IndexPath) -> CGFloat {
        if case .display = HomeTableViewDataSource.Index(rawValue: indexPath.section) {
            return self.view.bounds.height * 0.76
        }
        return self.view.bounds.height * 0.19
    }
    
    func viewDidScroll(in scrollView: UIScrollView) {
        guard let translation = scrollView.panGestureRecognizer.translation(in: self.view) as CGPoint? else { return }
        self.view.animateUsingSpring(withDuration: 0.66,
                                     withDamping: 1.0,
                                     initialSpringVelocity: 1.0) {
            guard translation.y < 0 else {
                self.navigationViewTopConstraint.constant = 0.0
                self.navigationView.alpha = 1.0
                return self.view.layoutIfNeeded()
            }
            self.navigationViewTopConstraint.constant = -self.navigationView.bounds.size.height
            self.navigationView.alpha = 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    func didSelectItem(at section: Int, of row: Int) {
        let section = viewModel.sections[section]
        let media = section.media[row]
        viewModel.actions?.presentMediaDetails(section, media, false)
    }
}

extension HomeViewController {
    private func tableViewState(in viewModel: HomeViewModel) {
        let tabBar = Application.current.coordinator.viewController as? TabBarController
        tabBar?.viewModel.coordinator?.tableViewState.observe(on: self) { [weak self] state in
//            guard let state = state as HomeTableViewDataSource.State? else { return }
//            print("Setupingg", viewModel.tableViewState, tabBar?.viewModel.coordinator?.tableViewState.value)
            self?.setupDataSource()
//            if state == .all {
//                self?.navigationView.viewModel.stateDidChange(.home)
//            } else if state == .series {
//                self?.navigationView.viewModel.stateDidChange(.tvShows)
//            } else if state == .films {
//                self?.navigationView.viewModel.stateDidChange(.movies)
//            } else {}
        }
    }
    
    private func presentedDisplayMedia(in viewModel: HomeViewModel) {
        viewModel.presentedDisplayMedia.observe(on: self) { [weak self] media in
            guard let media = media else { return }
            self!.categoriesOverlayView.opaqueView.viewModelDidUpdate(with: media)
        }
    }
}
