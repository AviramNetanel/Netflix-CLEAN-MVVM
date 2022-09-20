//
//  DefaultNavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 16/09/2022.
//

import UIKit

// MARK: - NavigationViewInput protocol

private protocol NavigationViewInput {
    var state: DefaultNavigationView.State { get }
}

// MARK: - NavigationViewOutput protocol

private protocol NavigationViewOutput {
    var dataSourceDidChange: ((DefaultNavigationView.State) -> Void)? { get }
}

// MARK: - NavigationView protocol

private protocol NavigationView: NavigationViewInput, NavigationViewOutput {}

// MARK: - DefaultNavigationView class

final class DefaultNavigationView: UIView, NavigationView, ViewInstantiable {
    
    enum State: Int {
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
    @IBOutlet private weak var tvShowsItemView: NavigationViewItem!
    @IBOutlet private weak var moviesItemView: NavigationViewItem!
    @IBOutlet private weak var categoriesItemView: NavigationViewItem!
    @IBOutlet private weak var itemsCenterXConstraint: NSLayoutConstraint!
    
    private(set) var viewModel: DefaultNavigationViewViewModel!
    
    fileprivate var state: State = .tvShows
    
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
                                  for state: DefaultNavigationView.State) -> DefaultNavigationViewViewModel {
        return DefaultNavigationViewViewModel(with: items, for: state)
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
    
    private func stateDidChange(in viewModel: DefaultNavigationViewViewModel) {
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
            case .airPlay:
                break
            case .account:
                break
            case .tvShows:
                self.tvShowsItemView.isHidden(false)
                self.moviesItemView.isHidden(true)
                self.categoriesItemView.isHidden(false)
                self.itemsCenterXConstraint.constant = -24.0
            case .movies:
                self.tvShowsItemView.isHidden(true)
                self.moviesItemView.isHidden(false)
                self.categoriesItemView.isHidden(false)
                self.itemsCenterXConstraint.constant = -32.0
            case .categories:
                break
            }
            
            self.animateUsingSpring(withDuration: 0.33,
                                    withDamping: 0.7,
                                    initialSpringVelocity: 0.7)
        }
    }
}
