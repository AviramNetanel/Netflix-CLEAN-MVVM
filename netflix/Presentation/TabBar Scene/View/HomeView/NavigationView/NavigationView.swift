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
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var stateDidChangeDidBindToHomeViewController: ((NavigationView.State) -> Void)? { get }
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
    @IBOutlet private weak var homeButton: NavigationViewItem!
    @IBOutlet private weak var airPlayButton: NavigationViewItem!
    @IBOutlet private weak var accountButton: NavigationViewItem!
    @IBOutlet private(set) weak var tvShowsItemView: NavigationViewItem!
    @IBOutlet private(set) weak var moviesItemView: NavigationViewItem!
    @IBOutlet private weak var categoriesItemView: NavigationViewItem!
    @IBOutlet private weak var itemsCenterXConstraint: NSLayoutConstraint!
    
    private(set) var viewModel: NavigationViewViewModel!
    
    var stateDidChangeDidBindToHomeViewController: ((State) -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibDidLoad()
        self.setupSubviews()
        let items: [NavigationViewItem] = [self.homeButton,
                                           self.airPlayButton,
                                           self.accountButton,
                                           self.tvShowsItemView,
                                           self.moviesItemView,
                                           self.categoriesItemView]
        self.viewModel = .init(items: items)
        self.viewDidLoad()
    }
    
    deinit {
        stateDidChangeDidBindToHomeViewController = nil
        viewModel = nil
    }
    
    private func setupSubviews() {
        addGradientLayer()
    }
    
    private func setupBindings() {
        stateDidChange(in: viewModel)
        buttonDidTap(for: viewModel.items)
    }
    
    private func setupObservers() {
        viewModel.state.observe(on: self) { [weak self] state in
            self?.viewModel.stateDidChangeDidBindToViewModel?(state)
        }
    }
    
    private func addGradientLayer() {
        gradientView.addGradientLayer(frame: gradientView.bounds,
                                      colors:
                                        [.black.withAlphaComponent(0.8),
                                         .black.withAlphaComponent(0.6),
                                         .clear],
                                      locations: [0.0, 0.5, 1.0])
    }
    
    fileprivate func viewDidLoad() {
        setupBindings()
        setupObservers()
    }
    
    func removeObservers() {
        printIfDebug("Removed `NavigationView` observers.")
        viewModel.state.remove(observer: self)
    }
}

// MARK: - Bindings

extension NavigationView {
    
    // MARK: NavigationViewViewModel bindings
    
    private func stateDidChange(in viewModel: NavigationViewViewModel) {
        viewModel.stateDidChangeDidBindToViewModel = { [weak self] state in
            guard let self = self else { return }
            
            self.stateDidChangeDidBindToHomeViewController?(state)
            
            self.categoriesItemView.viewDidConfigure(with: state)
            
            switch state {
            case .home:
                self.tvShowsItemView.isHidden(false)
                self.moviesItemView.isHidden(false)
                self.categoriesItemView.isHidden(false)
                self.itemsCenterXConstraint.constant = .zero
                
                self.tvShowsItemView.viewModel.hasInteracted = false
                self.moviesItemView.viewModel.hasInteracted = false
            case .airPlay:
                break
            case .account:
                break
            case .tvShows:
                self.tvShowsItemView.isHidden(false)
                self.moviesItemView.isHidden(true)
                self.categoriesItemView.isHidden(false)
                self.itemsCenterXConstraint.constant = -24.0
                
                self.tvShowsItemView.viewModel.hasInteracted = true
            case .movies:
                self.tvShowsItemView.isHidden(true)
                self.moviesItemView.isHidden(false)
                self.categoriesItemView.isHidden(false)
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
    
    private func buttonDidTap(for items: [NavigationViewItem]) {
        items.forEach {
            $0.configuration._buttonDidTap = { [weak self] state in
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
