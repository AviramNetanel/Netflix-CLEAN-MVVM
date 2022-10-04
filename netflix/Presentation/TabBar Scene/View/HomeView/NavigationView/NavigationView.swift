//
//  NavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    var state: NavigationView.State { get }
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var dataSourceDidChange: ((NavigationView.State) -> Void)? { get }
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
    
    fileprivate var state: State = .tvShows {
        didSet { viewModel.state.value = state }
    }
    
    var dataSourceDidChange: ((State) -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibDidLoad()
        self.setupSubviews()
        self.viewModel = viewModel(with: [self.homeButton,
                                          self.airPlayButton,
                                          self.accountButton,
                                          self.tvShowsItemView,
                                          self.moviesItemView,
                                          self.categoriesItemView],
                                   for: self.state)
        self.setupBindings()
    }
    
    private func viewModel(with items: [NavigationViewItem],
                           for state: NavigationView.State) -> NavigationViewViewModel {
        return NavigationViewViewModel(with: items, for: state)
    }
    
    private func setupSubviews() {
        addGradientLayer()
    }
    
    private func setupBindings() {
        stateDidChange(in: viewModel)
    }
    
    private func addGradientLayer() {
        gradientView.addGradientLayer(frame: gradientView.bounds,
                                      colors:
                                        [.black.withAlphaComponent(0.75),
                                         .black.withAlphaComponent(0.5),
                                         .clear],
                                      locations: [0.0, 0.5, 1.0])
    }
    
    private func stateDidChange(in viewModel: NavigationViewViewModel) {
        viewModel.stateDidChange = { [weak self] state in
            guard let self = self else { return }
            
            self.dataSourceDidChange?(state)
            self.categoriesItemView.configure(with: state)
            
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
