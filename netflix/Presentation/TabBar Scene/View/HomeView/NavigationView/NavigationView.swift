//
//  NavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import UIKit

// MARK: - NavigationViewDependencies protocol

protocol NavigationViewDependencies {
    func createNavigationView(on view: UIView) -> NavigationView
    func createNavigationViewViewModel(with items: [NavigationViewItem]) -> NavigationViewViewModel
    func createNavigationViewItems(on navigationView: NavigationView) -> [NavigationViewItem]
    func createNavigationViewViewModelActions() -> NavigationViewViewModelActions
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
    func viewDidConfigure()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var homeSceneDependencies: HomeViewDIProvider! { get }
    var homeItemView: NavigationViewItem! { get }
    var airPlayItemView: NavigationViewItem! { get }
    var accountItemView: NavigationViewItem! { get }
    var tvShowsItemView: NavigationViewItem! { get }
    var moviesItemView: NavigationViewItem! { get }
    var categoriesItemView: NavigationViewItem! { get }
    var viewModel: NavigationViewViewModel! { get }
}

// MARK: - View typelias

private typealias View = ViewInput & ViewOutput

// MARK: - NavigationView class

final class NavigationView: UIView, View, ViewInstantiable {
    
    enum State: Int, CaseIterable {
        case home
        case airPlay
        case account
        case tvShows
        case movies
        case categories
    }
    
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private(set) weak var homeItemViewContainer: UIView!
    @IBOutlet private(set) weak var airPlayItemViewContainer: UIView!
    @IBOutlet private(set) weak var accountItemViewContainer: UIView!
    @IBOutlet private(set) weak var tvShowsItemViewContainer: UIView!
    @IBOutlet private(set) weak var moviesItemViewContainer: UIView!
    @IBOutlet private(set) weak var categoriesItemViewContainer: UIView!
    @IBOutlet private(set) weak var itemsCenterXConstraint: NSLayoutConstraint!
    
    fileprivate var homeSceneDependencies: HomeViewDIProvider!
    var homeItemView: NavigationViewItem!
    var airPlayItemView: NavigationViewItem!
    var accountItemView: NavigationViewItem!
    var tvShowsItemView: NavigationViewItem!
    var moviesItemView: NavigationViewItem!
    var categoriesItemView: NavigationViewItem!
    fileprivate(set) var viewModel: NavigationViewViewModel!
    
    deinit {
        viewModel = nil
        categoriesItemView = nil
        moviesItemView = nil
        tvShowsItemView = nil
        accountItemView = nil
        airPlayItemView = nil
        homeItemView = nil
        homeSceneDependencies = nil
    }
    
    static func create(onParent parent: UIView, homeSceneDependencies: HomeViewDIProvider) -> NavigationView {
        let view = NavigationView(frame: parent.bounds)
        view.homeSceneDependencies = homeSceneDependencies
        view.nibDidLoad()
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        let items = homeSceneDependencies.createNavigationViewItems(on: view)
        view.viewModel = homeSceneDependencies.createNavigationViewViewModel(with: items)
        view.viewDidLoad()
        return view
    }
    
    private func setupBindings() {
        viewDidTap(in: viewModel.items)
    }
    
    private func setupObservers() {
        viewModel.state.observe(on: self) { [weak self] state in
            self?.viewModel.actions.stateDidChangeOnViewModel(self!.homeSceneDependencies.dependencies.homeViewController, state)
        }
    }
    
    private func setupGradientView() {
        gradientView.addGradientLayer(
            frame: gradientView.bounds,
            colors:
                [.black.withAlphaComponent(0.8),
                 .black.withAlphaComponent(0.6),
                 .clear],
            locations: [0.0, 0.5, 1.0])
    }
    
    fileprivate func viewDidLoad() {
        setupBindings()
        setupObservers()
        viewDidConfigure()
    }
    
    fileprivate func viewDidConfigure() {
        setupGradientView()
    }
    
    func removeObservers() {
        printIfDebug("Removed `NavigationView` observers.")
        viewModel.state.remove(observer: self)
    }
}

// MARK: - Closure bindings

extension NavigationView {
    
    // MARK: NavigationViewItem bindings
    
    private func viewDidTap(in items: [NavigationViewItem]) {
        items.forEach {
            $0.configuration._viewDidTap = { [weak self] state in
                self?.viewModel.state.value = state
            }
        }
    }
}

// MARK: - Valuable implementation

extension NavigationView.State: Valuable {
    
    var stringValue: String {
        switch self {
        case .home: return "Home"
        case .tvShows: return "TV Shows"
        case .movies: return "Movies"
        case .categories: return "Categories"
        default: return .init()
        }
    }
}
