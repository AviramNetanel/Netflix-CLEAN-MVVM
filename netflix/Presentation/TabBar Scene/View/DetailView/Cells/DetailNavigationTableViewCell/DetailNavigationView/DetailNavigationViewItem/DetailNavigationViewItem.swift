//
//  DetailNavigationViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - ConfigurationInput protocol

@objc
private protocol ConfigurationInput {
    func viewDidRegisterRecognizers()
    func viewDidConfigure()
    func viewDidTap()
}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {
    var view: DetailNavigationViewItem! { get }
    var navigationView: DetailNavigationView! { get }
}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - DetailNavigationViewItemConfiguration class

final class DetailNavigationViewItemConfiguration: Configuration {
    
    fileprivate weak var view: DetailNavigationViewItem!
    fileprivate weak var navigationView: DetailNavigationView!
    
    init(on view: DetailNavigationViewItem, with navigationView: DetailNavigationView) {
        self.view = view
        self.navigationView = navigationView
        self.viewDidRegisterRecognizers()
        self.viewDidConfigure()
    }
    
    deinit {
        view = nil
        navigationView = nil
    }
    
    fileprivate func viewDidRegisterRecognizers() {
        view.button.addTarget(self, action: #selector(viewDidTap), for: .touchUpInside)
    }
    
    fileprivate func viewDidConfigure() {
        if navigationView.viewModel?.dependencies.media.type == .series {
            navigationView.viewModel?.navigationViewState.value = .episodes
            navigationView.leadingViewContainer.isHidden(false)
            navigationView.centerViewContainer.isHidden(true)
        } else {
            navigationView.viewModel?.navigationViewState.value = .trailers
            navigationView.leadingViewContainer.isHidden(true)
            navigationView.centerViewContainer.isHidden(false)
        }
    }
    
    func viewDidTap() {
        if view.isSelected {
            view.widthConstraint?.constant = view.bounds.width
        } else {
            view.widthConstraint?.constant = .zero
        }
        
        view.isSelected.toggle()
        
        navigationView.stateDidChange(view: view)
    }
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var configuration: DetailNavigationViewItemConfiguration! { get }
    var viewModel: DetailNavigationViewItemViewModel! { get }
    var isSelected: Bool { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailNavigationViewItem class

final class DetailNavigationViewItem: UIView, View {
    
    fileprivate(set) var configuration: DetailNavigationViewItemConfiguration!
    fileprivate(set) var viewModel: DetailNavigationViewItemViewModel!
    
    private lazy var indicatorView = createIndicatorView()
    fileprivate lazy var button = createButton()
    
    var isSelected = false
    var widthConstraint: NSLayoutConstraint!
    
    init(on parent: UIView, with navigationView: DetailNavigationView) {
        super.init(frame: parent.bounds)
        self.tag = parent.tag
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.viewModel = .init(with: self)
        self.configuration = DetailNavigationViewItemConfiguration(on: self, with: navigationView)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        widthConstraint = nil
        configuration = nil
        viewModel = nil
    }
    
    private func createIndicatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemRed
        addSubview(view)
        return view
    }
    
    private func createButton() -> UIButton {
        let view = UIButton(type: .system)
        view.setTitle(viewModel.title, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        addSubview(view)
        return view
    }
    
    fileprivate func viewDidConfigure() {
        widthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: bounds.width)
        chainConstraintToSuperview(linking: indicatorView, to: button, withWidthAnchor: widthConstraint)
    }
}
