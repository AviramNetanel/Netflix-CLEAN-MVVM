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
                    .navigationViewStateDidChange(projectedValue: state)
                
                viewModel.coordinator?.viewController?.navigationView?.viewModel
                    .stateDidChange(projectedValue: state)
            })
        self.viewModel = NavigationViewViewModel(items: items, actions: actions, with: viewModel)
        viewModel.coordinator?.viewController?.navigationView = self
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

extension NavigationView {
    private func viewDidTap(in items: [NavigationViewItem]) {
        items.forEach {
            $0.configuration._viewDidTap = { [weak self] state in
                self?.viewModel.state.value = state
            }
        }
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
