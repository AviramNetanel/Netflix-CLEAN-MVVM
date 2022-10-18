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
    @IBOutlet private(set) var navigationViewContainer: UIView!
    @IBOutlet private var navigationViewTopConstraint: NSLayoutConstraint!
    
    private(set) var viewModel: HomeViewModel!
    private(set) var dataSource: TableViewDataSource!
    private(set) var navigationView: NavigationView!
    private(set) var categoriesOverlayView: CategoriesOverlayView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    deinit {
        navigationView = nil
        categoriesOverlayView = nil
        viewModel = nil
        dataSource = nil
    }
    
    static func create(with viewModel: HomeViewModel) -> HomeViewController {
        let view = Storyboard(withOwner: HomeTabBarController.self,
                              launchingViewController: HomeViewController.self)
            .instantiate() as! HomeViewController
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBehaviors()
        setupSubviews()
        setupBindings()
        viewModel.dataWillLoad()
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
        dataSource = .create(on: tableView, with: viewModel)
        heightForRowAt(in: dataSource)
        tableViewDidScroll(in: dataSource)
        didSelectItem(in: dataSource)
    }
    
    private func setupNavigationView() {
        navigationView = .create(on: navigationViewContainer)
        stateDidChange(in: navigationView)
    }
    
    private func setupCategoriesOverlayView() {
        categoriesOverlayView = .create(on: view)
        isPresentedDidChange(in: categoriesOverlayView)
    }
    
    private func setupSubviewsDependencies() {
        OpaqueView.createViewModel(on: categoriesOverlayView.opaqueView,
                                   with: viewModel)
    }
    
    func removeObservers() {
        if let viewModel = viewModel {
            printIfDebug("Removed `HomeViewModel` observers.")
            viewModel.state.remove(observer: self)
            viewModel.presentedDisplayMedia.remove(observer: self)
        }
    }
}

// MARK: - Bindings

extension HomeViewController {
    
    // MARK: HomeViewModel bindings
    
    private func navigationViewDidAppear(in viewModel: HomeViewModel) {
        viewModel.navigationViewDidAppear = { [weak self] in
            guard let self = self else { return }
            self.navigationViewTopConstraint.constant = 0.0
            self.navigationView.alpha = 1.0
            self.view.animateUsingSpring(withDuration: 0.66,
                                         withDamping: 1.0,
                                         initialSpringVelocity: 1.0)
        }
    }
    
    // MARK: TableViewDataSource bindings
    
    private func heightForRowAt(in dataSource: TableViewDataSource) {
        dataSource.heightForRowAt = { [weak self] indexPath in
            guard let self = self else { return .zero }
            if case .display = TableViewDataSource.Index(rawValue: indexPath.section) {
                return self.view.bounds.height * 0.76
            }
            return self.view.bounds.height * 0.19
        }
    }
    
    private func tableViewDidScroll(in dataSource: TableViewDataSource) {
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
                    self.navigationViewTopConstraint.constant = 0.0
                    self.navigationView.alpha = 1.0
                    return self.view.layoutIfNeeded()
                }
                self.navigationViewTopConstraint.constant = -162.0
                self.navigationView.alpha = 0.0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func didSelectItem(in dataSource: TableViewDataSource) {
        dataSource.didSelectItem = { [weak self] section, row in
            guard let self = self else { return }
            let section = self.viewModel.state.value == .tvShows
                ? self.viewModel.sections.value[section]
                : self.viewModel.sections.value[section]
            let media = self.viewModel.state.value == .tvShows
                ? section.media[row]
                : section.media[row]
            self.viewModel.actions.presentMediaDetails(section, media)
        }
    }
    
    // MARK: NavigationView bindings
    
    private func stateDidChange(in navigationView: NavigationView) {
        navigationView.viewModel.stateDidChangeDidBindToHomeViewController = { [weak self] state in
            guard
                let self = self
            else { return }
            
            self.categoriesOverlayView.viewModel.state = state
            
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
    
    // MARK: CategoriesOverlayView bindings
    
    private func isPresentedDidChange(in categoriesOverlayView: CategoriesOverlayView) {
        categoriesOverlayView.viewModel._isPresentedDidChange = { [weak self] in
            categoriesOverlayView.viewModel.isPresented.value == true
                ? self?.tabBarController?.tabBar.isHidden(true)
                : self?.tabBarController?.tabBar.isHidden(false)
        }
    }
}

// MARK: - Observers

extension HomeViewController {
    
    // MARK: HomeViewModel observers
    
    private func state(in viewModel: HomeViewModel) {
        viewModel.state.observe(on: self) { [weak self] _ in
            self?.setupDataSource()
        }
    }
    
    private func presentedDisplayMedia(in viewModel: HomeViewModel) {
        viewModel.presentedDisplayMedia.observe(on: self) { [weak self] _ in
            self?.setupSubviewsDependencies()
        }
    }
}
