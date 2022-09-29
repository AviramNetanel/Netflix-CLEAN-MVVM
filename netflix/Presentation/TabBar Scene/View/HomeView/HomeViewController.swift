//
//  HomeViewController.swift
//  netflix
//
//  Created by Zach Bazov on 31/08/2022.
//

import UIKit

// MARK: - HomeViewController class

final class HomeViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private(set) var navigationView: DefaultNavigationView!
    @IBOutlet private var navigationViewHeightConstraint: NSLayoutConstraint!
    
    private var viewModel: DefaultHomeViewModel!
    
    private(set) var dataSource: DefaultTableViewDataSource!
    private(set) var categoriesOverlayView: DefaultCategoriesOverlayView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupSubviews()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    static func create(with viewModel: DefaultHomeViewModel) -> HomeViewController {
        let view = UIStoryboard(name: String(describing: HomeTabBarController.self),
                                bundle: nil)
            .instantiateViewController(
                withIdentifier: String(describing: HomeViewController.self)) as! HomeViewController
        view.viewModel = viewModel
        return view
    }
    
    deinit {
        categoriesOverlayView = nil
        viewModel = nil
        dataSource = nil
    }
    
    private func setupBehaviors() {
        addBehaviors([BackButtonEmptyTitleNavigationBarBehavior(),
                      BlackStyleNavigationBarBehavior()])
    }
    
    private func setupSubviews() {
        setupDataSource()
        setupNavigationView()
        setupCategoriesOverlayView()
    }
    
    private func setupBindings() {
        state(in: viewModel)
        navigationViewDidAppear(in: viewModel)
        presentedDisplayMedia(in: viewModel)
    }
    
    private func setupDataSource() {
        dataSource = .init(in: tableView, with: viewModel)
        heightForRowAt(in: dataSource)
        tableViewDidScroll(in: dataSource)
    }
    
    private func setupNavigationView() {
        dataSourceDidChange(in: navigationView)
    }
    
    private func setupCategoriesOverlayView() {
        categoriesOverlayView = DefaultCategoriesOverlayView.create(on: view)
    }
    
    private func setupSubviewsDependencies() {
        DefaultOpaqueView.createViewModel(on: categoriesOverlayView.opaqueView,
                                          with: viewModel)
    }
    
    func removeObservers() {
        printIfDebug("Removed `DefaultHomeViewModel` observers.")
        viewModel.state.remove(observer: self)
        viewModel.presentedDisplayMedia.remove(observer: self)
    }
}

// MARK: - Bindings

extension HomeViewController {
    
    private func heightForRowAt(in dataSource: DefaultTableViewDataSource) {
        dataSource.heightForRowAt = { [weak self] indexPath in
            guard let self = self else { return .zero }
            if case .display = DefaultTableViewDataSource.Index(rawValue: indexPath.section) {
                return self.view.bounds.height * 0.76
            }
            return self.view.bounds.height * 0.19
        }
    }
    
    private func dataSourceDidChange(in navigationView: DefaultNavigationView) {
        navigationView.dataSourceDidChange = { [weak self] state in
            guard let self = self else { return }
            
            self.categoriesOverlayView.viewModel.state = state
            
            if self.categoriesOverlayView.viewModel.dataSource.tabBarController == nil {
                self.categoriesOverlayView.viewModel.dataSource.tabBarController = self.tabBarController
            }
            
            switch state {
            case .home:
                self.categoriesOverlayView.viewModel.isPresented.value = false
            case .tvShows:
                guard self.viewModel.state.value != .tvShows else {
                    guard navigationView.tvShowsItemView.viewModel.hasInteracted else {
                        return self.categoriesOverlayView.viewModel.isPresented.value = false
                    }
                    return self.categoriesOverlayView.viewModel.isPresented.value = true
                }
                self.viewModel.state.value = .tvShows
            case .movies:
                guard self.viewModel.state.value != .movies else {
                    guard navigationView.moviesItemView.viewModel.hasInteracted else {
                        return self.categoriesOverlayView.viewModel.isPresented.value = false
                    }
                    return self.categoriesOverlayView.viewModel.isPresented.value = true
                }
                self.viewModel.state.value = .movies
            case .categories:
                self.categoriesOverlayView?.viewModel.isPresented.value = true
            default: return
            }
        }
    }
    
    private func tableViewDidScroll(in dataSource: DefaultTableViewDataSource) {
        dataSource.tableViewDidScroll = { [weak self] scrollView in
            guard
                let self = self,
                let translation = scrollView.panGestureRecognizer
                                            .translation(in: self.view) as CGPoint?
            else { return }
            self.view.animateUsingSpring(withDuration: 0.66,
                                         withDamping: 1.0,
                                         initialSpringVelocity: 1.0) {
                guard translation.y < 0 else {
                    self.navigationViewHeightConstraint.constant = 0.0
                    self.navigationView.alpha = 1.0
                    return self.view.layoutIfNeeded()
                }
                self.navigationViewHeightConstraint.constant = -162.0
                self.navigationView.alpha = 0.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func navigationViewDidAppear(in viewModel: DefaultHomeViewModel) {
        viewModel.navigationViewDidAppear = { [weak self] in
            guard let self = self else { return }
            self.navigationViewHeightConstraint.constant = 0.0
            self.navigationView.alpha = 1.0
            self.view.animateUsingSpring(withDuration: 0.66,
                                         withDamping: 1.0,
                                         initialSpringVelocity: 1.0)
        }
    }
}

// MARK: - DefaultHomeViewModel Observers

extension HomeViewController {
    
    private func state(in viewModel: DefaultHomeViewModel) {
        viewModel.state.observe(on: self) { [weak self] _ in self?.setupDataSource() }
    }
    
    private func presentedDisplayMedia(in viewModel: DefaultHomeViewModel) {
        viewModel.presentedDisplayMedia.observe(on: self) { [weak self] _ in self?.setupSubviewsDependencies() }
    }
}
