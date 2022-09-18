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

private protocol NavigationViewOutput {}

// MARK: - NavigationView protocol

private protocol NavigationView: NavigationViewInput, NavigationViewOutput {}

// MARK: - DefaultNavigationView class

final class DefaultNavigationView: UIView, NavigationView, ViewInstantiable {
    
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var homeButton: UIButton!
    @IBOutlet private weak var tvShowsItemView: NavigationItemView!
    @IBOutlet private weak var moviesItemView: NavigationItemView!
    @IBOutlet private weak var categoriesItemView: NavigationItemView!
    @IBOutlet private weak var itemsCenterXConstraint: NSLayoutConstraint!
    
    private(set) var viewModel: DefaultNavigationViewViewModel!
    
    fileprivate var state: State = .tvShows
    
    enum State: Int, CaseIterable {
        case home = 0
        case tvShows = 3
        case movies = 4
        case categories = 5
//        case tvShowsCategories
//        case moviesCategories
    }
    
    static func create(on parent: UIView) -> DefaultNavigationView {
        let view = DefaultNavigationView.instantiateSubview(onParent: parent) as! DefaultNavigationView
        view.constraint(to: parent)
        view.setupSubviews()
        view.viewModel = viewModel(with: [//view.homeButton,
                                          view.tvShowsItemView,
                                          view.moviesItemView,
                                          view.categoriesItemView],
                                   for: view.state)
        view.setupBindings()
        return view
    }
    
    private static func viewModel(with items: [NavigationItemView],
                                  for state: DefaultNavigationView.State) -> DefaultNavigationViewViewModel {
        let viewModel = DefaultNavigationViewViewModel(with: items, for: state)
        return viewModel
    }
    
    private func constraint(to parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: parent.topAnchor),
            leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            heightAnchor.constraint(equalToConstant: 162.0)
        ])
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
            switch state {
            case .home:
                print(11)
            case .tvShows:
                self.itemsCenterXConstraint.constant = -32.0
                self.moviesItemView.isHidden = true
                self.categoriesItemView.isHidden = true
            case .movies:
                self.itemsCenterXConstraint.constant = .zero
                self.moviesItemView.isHidden = false
                self.categoriesItemView.isHidden = false
            case .categories:
                break
            }
            UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7) {
                self.layoutIfNeeded()
            }
        }
    }
}
