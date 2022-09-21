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
    @IBOutlet private(set) var navigationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var categoriesOverlayView: DefaultCategoriesOverlayView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    var viewModel: DefaultHomeViewModel!
    
    private(set) var dataSource: DefaultTableViewDataSource!
    
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
        presentNavigationView(in: viewModel)
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
        categoriesDidTap(in: categoriesOverlayView.viewModel)
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
            switch state {
            case .home: return
            case .tvShows: guard self.viewModel.state.value != .tvShows else { return }
            case .movies: guard self.viewModel.state.value != .movies else { return }
            case .categories: self.categoriesOverlayView.viewModel.categoriesDidTap?()
            default: return
            }
            self.viewModel.state.value = state == .tvShows ? .tvShows : .movies
        }
    }
    
    private func tableViewDidScroll(in dataSource: DefaultTableViewDataSource) {
        dataSource.tableViewDidScroll = { [weak self] scrollView in
            guard
                let self = self,
                let translation = scrollView
                    .panGestureRecognizer
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
    
    private func presentNavigationView(in viewModel: DefaultHomeViewModel) {
        viewModel.presentNavigationView = { [weak self] in
            guard let self = self else { return }
            self.navigationViewHeightConstraint.constant = 0.0
            self.navigationView.alpha = 1.0
            self.view.animateUsingSpring(withDuration: 0.66,
                                         withDamping: 1.0,
                                         initialSpringVelocity: 1.0)
        }
    }
    
    private func categoriesDidTap(in viewModel: DefaultCategoriesOverlayViewViewModel) {
        viewModel.categoriesDidTap = { viewModel.isPresented.value = true }
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
