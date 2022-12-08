//
//  NavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import UIKit

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
    @IBOutlet private weak var homeItemViewContainer: UIView!
    @IBOutlet private weak var airPlayItemViewContainer: UIView!
    @IBOutlet private weak var accountItemViewContainer: UIView!
    @IBOutlet private(set) weak var tvShowsItemViewContainer: UIView!
    @IBOutlet private(set) weak var moviesItemViewContainer: UIView!
    @IBOutlet private(set) weak var categoriesItemViewContainer: UIView!
    @IBOutlet private(set) weak var itemsCenterXConstraint: NSLayoutConstraint!
    
    private(set) var viewModel: NavigationViewViewModel!
    
    private(set) var homeItemView: NavigationViewItem!
    private var airPlayItemView: NavigationViewItem!
    private var accountItemView: NavigationViewItem!
    private(set) var tvShowsItemView: NavigationViewItem!
    private(set) var moviesItemView: NavigationViewItem!
    private(set) var categoriesItemView: NavigationViewItem!
    
    init(on parent: UIView, with viewModel: HomeViewModel) {
        super.init(frame: parent.bounds)
        self.nibDidLoad()
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        
        self.homeItemView = NavigationViewItem(onParent: self.homeItemViewContainer, with: viewModel)
        self.airPlayItemView = NavigationViewItem(onParent: self.airPlayItemViewContainer, with: viewModel)
        self.accountItemView = NavigationViewItem(onParent: self.accountItemViewContainer, with: viewModel)
        self.tvShowsItemView = NavigationViewItem(onParent: self.tvShowsItemViewContainer, with: viewModel)
        self.moviesItemView = NavigationViewItem(onParent: self.moviesItemViewContainer, with: viewModel)
        self.categoriesItemView = NavigationViewItem(onParent: self.categoriesItemViewContainer, with: viewModel)
        let items: [NavigationViewItem] = [self.homeItemView, self.airPlayItemView,
                                           self.accountItemView, self.tvShowsItemView,
                                           self.moviesItemView, self.categoriesItemView]
        let actions = NavigationViewViewModelActions(
            stateDidChange: { state in
                let navigation = viewModel.coordinator?.viewController?.navigationView
                let categoriesOverlay = viewModel.coordinator?.viewController?.categoriesOverlayView
                navigation?.viewModel.stateDidChange(state)
                categoriesOverlay?.viewModel.coordinateStateChanges(for: state)
            })
        self.viewModel = NavigationViewViewModel(items: items, actions: actions, with: viewModel)
        
        /// Updates root coordinator's `navigationView` property.
        viewModel.coordinator?.viewController?.navigationView = self
        
        self.viewDidLoad()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        homeItemView = nil
        airPlayItemView = nil
        accountItemView = nil
        tvShowsItemView = nil
        moviesItemView = nil
        categoriesItemView = nil
        viewModel = nil
    }
    
    private func setupObservers() {
        viewModel.state.observe(on: self) { [weak self] state in
            self?.viewModel.actions.stateDidChange(state)
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
