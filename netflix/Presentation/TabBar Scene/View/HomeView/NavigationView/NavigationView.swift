//
//  NavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
    func viewDidConfigure()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
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
    @IBOutlet private weak var homeItemViewContainer: UIView!
    @IBOutlet private weak var airPlayItemViewContainer: UIView!
    @IBOutlet private weak var accountItemViewContainer: UIView!
    @IBOutlet private(set) weak var tvShowsItemViewContainer: UIView!
    @IBOutlet private(set) weak var moviesItemViewContainer: UIView!
    @IBOutlet private weak var categoriesItemViewContainer: UIView!
    @IBOutlet private weak var itemsCenterXConstraint: NSLayoutConstraint!
    
    fileprivate(set) var homeItemView: NavigationViewItem!
    fileprivate var airPlayItemView: NavigationViewItem!
    fileprivate var accountItemView: NavigationViewItem!
    fileprivate(set) var tvShowsItemView: NavigationViewItem!
    fileprivate(set) var moviesItemView: NavigationViewItem!
    fileprivate var categoriesItemView: NavigationViewItem!
    
    fileprivate(set) var viewModel: NavigationViewViewModel!
    
    deinit {
        homeItemView = nil
        airPlayItemView = nil
        accountItemView = nil
        tvShowsItemView = nil
        moviesItemView = nil
        categoriesItemView = nil
        viewModel = nil
    }
    
    static func create(on parent: UIView) -> NavigationView {
        let view = NavigationView(frame: parent.bounds)
        view.nibDidLoad()
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        createItems(on: view)
        createViewModel(on: view)
        view.viewDidLoad()
        return view
    }
    
    @discardableResult
    private static func createViewModel(on view: NavigationView) -> NavigationViewViewModel {
        let items: [NavigationViewItem] = [view.homeItemView,
                                           view.airPlayItemView,
                                           view.accountItemView,
                                           view.tvShowsItemView,
                                           view.moviesItemView,
                                           view.categoriesItemView]
        view.viewModel = .init(items: items)
        return view.viewModel
    }
    
    private static func createItems(on view: NavigationView) {
        view.homeItemView = .create(on: view.homeItemViewContainer)
        view.airPlayItemView = .create(on: view.airPlayItemViewContainer)
        view.accountItemView = .create(on: view.accountItemViewContainer)
        view.tvShowsItemView = .create(on: view.tvShowsItemViewContainer)
        view.moviesItemView = .create(on: view.moviesItemViewContainer)
        view.categoriesItemView = .create(on: view.categoriesItemViewContainer)
    }
    
    fileprivate func viewDidLoad() {
        viewDidBind()
        viewDidObserve()
        viewDidConfigure()
    }
    
    fileprivate func viewDidConfigure() {
        setupGradientView()
    }
    
    private func setupGradientView() {
        gradientView.addGradientLayer(frame: gradientView.bounds,
                                      colors:
                                        [.black.withAlphaComponent(0.8),
                                         .black.withAlphaComponent(0.6),
                                         .clear],
                                      locations: [0.0, 0.5, 1.0])
    }
}

// MARK: -

extension NavigationView: ObservableDelegate {
    
    func viewDidObserve() {
        viewModel.state.observe(on: self) { [weak self] state in
            self?.viewModel.stateDidChangeDidBindToViewModel?(state)
        }
    }
    
    func viewDidUnobserve() {
        printIfDebug("Removed `NavigationView` observers.")
        viewModel.state.remove(observer: self)
    }
    
    func viewDidBind() {
        stateDidChange(in: viewModel)
        viewDidTap(in: viewModel.items)
    }
}

// MARK: - Bindings implementation

extension NavigationView {
    
    // MARK: NavigationViewViewModel bindings
    
    private func stateDidChange(in viewModel: NavigationViewViewModel) {
        viewModel.stateDidChangeDidBindToViewModel = { [weak self] state in
            guard let self = self else { return }
            
            self.viewModel.stateDidChangeDidBindToHomeViewController?(state)
            
            self.categoriesItemView.viewDidConfigure(with: state)
            
            switch state {
            case .home:
                self.tvShowsItemViewContainer.isHidden(false)
                self.moviesItemViewContainer.isHidden(false)
                self.categoriesItemViewContainer.isHidden(false)
                self.itemsCenterXConstraint.constant = .zero
                
                self.tvShowsItemView.viewModel.hasInteracted = false
                self.moviesItemView.viewModel.hasInteracted = false
            case .airPlay:
                break
            case .account:
                break
            case .tvShows:
                self.tvShowsItemViewContainer.isHidden(false)
                self.moviesItemViewContainer.isHidden(true)
                self.categoriesItemViewContainer.isHidden(false)
                self.itemsCenterXConstraint.constant = -24.0
                
                self.tvShowsItemView.viewModel.hasInteracted = true
            case .movies:
                self.tvShowsItemViewContainer.isHidden(true)
                self.moviesItemViewContainer.isHidden(false)
                self.categoriesItemViewContainer.isHidden(false)
                self.itemsCenterXConstraint.constant = -32.0
                
                self.moviesItemView.viewModel.hasInteracted = true
            case .categories:
                break
            }
            
            self.animateUsingSpring(withDuration: 0.33,
                                    withDamping: 0.7,
                                    initialSpringVelocity: 0.7)
        }
    }
    
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
