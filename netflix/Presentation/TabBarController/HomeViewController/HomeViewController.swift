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
    
    var viewModel: HomeViewModel!
    var navigationView: NavigationView!
    var browseOverlayView: BrowseOverlayView!
    var dataSource: HomeTableViewDataSource!
    
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
        setupBrowseOverlayView()
    }
    
    private func setupObservers() {
        tableViewState(in: viewModel)
        presentedDisplayMedia(in: viewModel)
    }
    
    private func setupDataSource() {
        /// Filters the sections based on the data source state.
        viewModel.filter(sections: viewModel.sections)
        /// Initializes the data source.
        dataSource = HomeTableViewDataSource(tableView: tableView, viewModel: viewModel)
    }
    
    private func setupNavigationView() {
        navigationView = NavigationView(on: navigationViewContainer, with: viewModel)
    }
    
    private func setupBrowseOverlayView() {
        browseOverlayView = BrowseOverlayView(on: browseOverlayViewContainer, with: viewModel)
    }
    
    func removeObservers() {
        if let viewModel = viewModel,
           let tabBarViewModel = Application.current.rootCoordinator.tabCoordinator.viewController?.viewModel {
            printIfDebug("Removed `HomeViewModel` observers.")
            tabBarViewModel.tableViewState.remove(observer: self)
            viewModel.presentedDisplayMedia.remove(observer: self)
        }
    }
    
    func terminate() {
        navigationView.removeFromSuperview()
        navigationView = nil

        browseOverlayView.removeFromSuperview()
        browseOverlayView = nil
        
        viewModel.myList.removeObservers()
        viewModel.coordinator = nil
        viewModel.myList = nil
        viewModel = nil
        
        removeObservers()
        removeFromParent()
    }
}

extension HomeViewController {
    private func tableViewState(in viewModel: HomeViewModel) {
        guard let tabBar = Application.current.rootCoordinator.viewController as? TabBarController,
              let tabBarViewModel = tabBar.viewModel else {
            return
        }
        tabBarViewModel.tableViewState.observe(on: self) { [weak self] state in
            self?.setupDataSource()
        }
    }
    
    private func presentedDisplayMedia(in viewModel: HomeViewModel) {
        viewModel.presentedDisplayMedia.observe(on: self) { [weak self] media in
            guard let media = media else { return }
            self!.navigationView.navigationOverlayView.opaqueView.viewModelDidUpdate(with: media)
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
