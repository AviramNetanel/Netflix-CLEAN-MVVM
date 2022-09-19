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
    @IBOutlet private weak var homeButton: NavigationViewItem!
    @IBOutlet private weak var airPlayButton: NavigationViewItem!
    @IBOutlet private weak var accountButton: NavigationViewItem!
    @IBOutlet private weak var tvShowsItemView: NavigationViewItem!
    @IBOutlet private weak var moviesItemView: NavigationViewItem!
    @IBOutlet private weak var categoriesItemView: NavigationViewItem!
    @IBOutlet private weak var itemsCenterXConstraint: NSLayoutConstraint!
    
    private(set) var viewModel: DefaultNavigationViewViewModel!
    
    fileprivate var state: State = .tvShows
    
    enum State: Int, CaseIterable {
        case home
        case airPlay
        case account
        case tvShows
        case movies
        case categories
    }
    
    static func create(on parent: UIView) -> DefaultNavigationView {
        let view = DefaultNavigationView.instantiateSubview(onParent: parent) as! DefaultNavigationView
        view.constraint(to: parent)
        view.setupSubviews()
        view.viewModel = viewModel(with: [view.homeButton,
                                          view.airPlayButton,
                                          view.accountButton,
                                          view.tvShowsItemView,
                                          view.moviesItemView,
                                          view.categoriesItemView],
                                   for: view.state)
        view.setupBindings()
        return view
    }
    
    private static func viewModel(with items: [NavigationViewItem],
                                  for state: DefaultNavigationView.State) -> DefaultNavigationViewViewModel {
        return DefaultNavigationViewViewModel(with: items, for: state)
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
                                    withDamping: 0.7,initialSpringVelocity: 0.7)
        }
    }
}

extension UIView {
    func animateUsingSpring(withDuration duration: TimeInterval,
                            withDamping damping: CGFloat,
                            initialSpringVelocity velocity: CGFloat) {
        UIView.animate(withDuration: duration,
                       delay: .zero,
                       usingSpringWithDamping: damping,
                       initialSpringVelocity: velocity) { [unowned self] in layoutIfNeeded() }
    }
}
