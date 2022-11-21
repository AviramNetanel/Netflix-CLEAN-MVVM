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
        let view = Storyboard(
            withOwner: HomeTabBarController.self,
            launchingViewController: HomeViewController.self)
            .instantiate() as! HomeViewController
        view.viewModel = viewModel
        view.viewModel.myListDidSetup = view.setupList
        return view
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
    }
    
    private func setupObservers() {
        tableViewState(in: viewModel)
        presentedDisplayMedia(in: viewModel)
    }
    
    private func setupDataSource() {
        viewModel.filter(sections: viewModel.sections)
        dataSource = .create(on: tableView, with: viewModel)
        heightForRowAt(in: dataSource)
        tableViewDidScroll(in: dataSource)
        didSelectItem(in: dataSource)
    }
    
    private func setupNavigationView() {
        navigationView = .create(on: navigationViewContainer)
        navigationViewDidAppear(in: viewModel)
        stateDidChange(in: navigationView)
    }
    
    private func setupCategoriesOverlayView() {
        categoriesOverlayView = .create(on: view)
        isPresentedDidChange(in: categoriesOverlayView)
    }
    
    private func setupList() {
        viewModel.myList = .init(with: viewModel)
        listDidReload(in: viewModel)
    }
    
    private func setupSubviewsDependencies() {
        OpaqueView.createViewModel(on: categoriesOverlayView.opaqueView,
                                   with: viewModel)
    }
    
    func unbindObservers() {
        if let viewModel = viewModel {
            printIfDebug("Removed `HomeViewModel` observers.")
            viewModel.tableViewState.remove(observer: self)
            viewModel.presentedDisplayMedia.remove(observer: self)
        }
    }
}

// MARK: - Closure bindings

extension HomeViewController {
    
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
    
    private func listDidReload(in viewModel: HomeViewModel) {
        viewModel.myList.listDidReload = { [weak self] in
            guard
                let self = self,
                self.tableView.numberOfSections > 0,
                let myListIndex = TableViewDataSource.Index(rawValue: 6)
            else { return }
            let section = self.viewModel.section(at: .myList)
            self.viewModel.filter(section: section)
            let index = IndexSet(integer: myListIndex.rawValue)
            self.tableView.reloadSections(index, with: .automatic)
        }
    }
    
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
                let translation = scrollView.panGestureRecognizer.translation(in: self.view) as CGPoint?
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
            let section = self.viewModel.sections[section]
            let media = section.media[row]
            self.viewModel.actions.presentMediaDetails(section, media)
        }
    }
    
    private func stateDidChange(in navigationView: NavigationView) {
        navigationView.viewModel.stateDidChangeDidBindToHomeViewController = { [weak self] state in
            guard let self = self else { return }
            
            self.categoriesOverlayView.viewModel.navigationViewState = state
            
            switch state {
            case .home:
                guard self.viewModel.tableViewState.value != .all else {
                    guard navigationView.homeItemView.viewModel.hasInteracted else {
                        return self.categoriesOverlayView.viewModel.isPresented.value = false
                    }
                    return self.categoriesOverlayView.viewModel.isPresented.value = true
                }
                
                self.viewModel.tableViewState.value = .all
                self.categoriesOverlayView.viewModel.state = .mainMenu
            case .tvShows:
                guard self.viewModel.tableViewState.value != .series else {
                    guard navigationView.tvShowsItemView.viewModel.hasInteracted else {
                        return self.categoriesOverlayView.viewModel.isPresented.value = false
                    }
                    return self.categoriesOverlayView.viewModel.isPresented.value = true
                }
                
                self.viewModel.tableViewState.value = .series
                self.categoriesOverlayView.viewModel.state = .mainMenu
            case .movies:
                guard self.viewModel.tableViewState.value != .films else {
                    guard navigationView.moviesItemView.viewModel.hasInteracted else {
                        return self.categoriesOverlayView.viewModel.isPresented.value = false
                    }
                    return self.categoriesOverlayView.viewModel.isPresented.value = true
                }
                
                self.viewModel.tableViewState.value = .films
                self.categoriesOverlayView.viewModel.state = .mainMenu
            case .categories:
                self.categoriesOverlayView.viewModel.isPresented.value = true
                self.categoriesOverlayView.viewModel.state = .categories
            default: return
            }
        }
    }
    
    private func isPresentedDidChange(in categoriesOverlayView: CategoriesOverlayView) {
        categoriesOverlayView.viewModel.isPresentedDidChange = { [weak self] in
            categoriesOverlayView.viewModel.isPresented.value == true
                ? self?.tabBarController?.tabBar.isHidden(true)
                : self?.tabBarController?.tabBar.isHidden(false)
        }
    }
}

// MARK: - Observer bindings

extension HomeViewController {
    
    private func tableViewState(in viewModel: HomeViewModel) {
        viewModel.tableViewState.observe(on: self) { [weak self] _ in
            self?.setupDataSource()
        }
    }
    
    private func presentedDisplayMedia(in viewModel: HomeViewModel) {
        viewModel.presentedDisplayMedia.observe(on: self) { [weak self] _ in
            self?.setupSubviewsDependencies()
        }
    }
}

/*
 // MARK: - Observers struct

 private struct Observers {
     
     var tableViewState: (() -> Void)?
     var presentedDisplayMedia: (() -> Void)?
     
     static func create(on viewModel: HomeViewModel,
                        tableViewState: @escaping () -> Void,
                        presentedDisplayMedia: @escaping () -> Void) -> Observers {
         var observers = Observers()
         observers.tableViewState = tableViewState
         viewModel.tableViewState.observe(on: viewModel) { _ in
             tableViewState()
         }
         observers.presentedDisplayMedia = presentedDisplayMedia
         viewModel.presentedDisplayMedia.observe(on: viewModel) { _ in
             presentedDisplayMedia()
         }
         return observers
     }
 }
 */
