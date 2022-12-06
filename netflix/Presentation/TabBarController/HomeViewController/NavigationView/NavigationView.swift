//
//  NavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import UIKit

// MARK: - NavigationViewDependencies protocol

protocol NavigationViewDependencies {
    func createNavigationView() -> NavigationView
    func createNavigationViewViewModel(with items: [NavigationViewItem]) -> NavigationViewViewModel
    func createNavigationViewViewModelActions() -> NavigationViewViewModelActions
}

//// MARK: - ViewInput protocol
//
//private protocol ViewInput {
//    func viewDidLoad()
//    func viewDidConfigure()
//}
//
//// MARK: - ViewOutput protocol
//
//private protocol ViewOutput {
//    var homeItemView: NavigationViewItem! { get }
//    var airPlayItemView: NavigationViewItem! { get }
//    var accountItemView: NavigationViewItem! { get }
//    var tvShowsItemView: NavigationViewItem! { get }
//    var moviesItemView: NavigationViewItem! { get }
//    var categoriesItemView: NavigationViewItem! { get }
//    var viewModel: NavigationViewViewModel! { get }
//}
//
//// MARK: - View typelias
//
//private typealias View = ViewInput & ViewOutput

// MARK: - NavigationView class

final class NavigationView: UIView, ViewInstantiable {
    
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
    
    fileprivate(set) var homeItemView: NavigationViewItem!
    fileprivate var airPlayItemView: NavigationViewItem!
    fileprivate var accountItemView: NavigationViewItem!
    fileprivate(set) var tvShowsItemView: NavigationViewItem!
    fileprivate(set) var moviesItemView: NavigationViewItem!
    fileprivate(set) var categoriesItemView: NavigationViewItem!
    var viewModel: NavigationViewViewModel!
    
    init(on parent: UIView, with viewModel: HomeViewModel) {
        super.init(frame: parent.bounds)
        self.nibDidLoad()
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.homeItemView = NavigationViewItem(onParent: self.homeItemViewContainer)
        self.airPlayItemView = NavigationViewItem(onParent: self.airPlayItemViewContainer)
        self.accountItemView = NavigationViewItem(onParent: self.accountItemViewContainer)
        self.tvShowsItemView = NavigationViewItem(onParent: self.tvShowsItemViewContainer)
        self.moviesItemView = NavigationViewItem(onParent: self.moviesItemViewContainer)
        self.categoriesItemView = NavigationViewItem(onParent: self.categoriesItemViewContainer)
        let items: [NavigationViewItem] = [self.homeItemView, self.airPlayItemView, self.accountItemView,
                                           self.tvShowsItemView, self.moviesItemView, self.categoriesItemView]
        let actions = NavigationViewViewModelActions(
            stateDidChange: { state in
                viewModel.coordinator?.viewController?.categoriesOverlayView?.viewModel
                    .navigationViewStateDidChange(withOwner: viewModel.coordinator!.viewController!,
                                                  projectedValue: state)
                
                viewModel.coordinator?.viewController?.navigationView?.viewModel
                    .stateDidChange(withOwner: viewModel.coordinator!.viewController!,
                                    projectedValue: state)
            })
        self.viewModel = NavigationViewViewModel(items: items, actions: actions)
        self.viewDidLoad()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        categoriesItemView = nil
        moviesItemView = nil
        tvShowsItemView = nil
        accountItemView = nil
        airPlayItemView = nil
        homeItemView = nil
        viewModel = nil
    }
    
    private func setupBindings() {
        viewDidTap(in: viewModel.items)
    }
    
    private func setupObservers() {
        viewModel.state.observe(on: self) { [weak self] state in self?.viewModel.actions.stateDidChange(state) }
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
