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
    
    deinit {
        view = nil
        navigationView = nil
    }
    
    static func create(on view: DetailNavigationViewItem,
                       with navigationView: DetailNavigationView) -> DetailNavigationViewItemConfiguration {
        let configuration = DetailNavigationViewItemConfiguration()
        configuration.view = view
        configuration.navigationView = navigationView
        configuration.viewDidRegisterRecognizers()
        configuration.viewDidConfigure()
        return configuration
    }
    
    fileprivate func viewDidRegisterRecognizers() {
        view.button.addTarget(self,
                              action: #selector(viewDidTap),
                              for: .touchUpInside)
    }
    
    fileprivate func viewDidConfigure() {
      if navigationView.viewModel.media.type == .series {
            navigationView.viewModel.navigationViewState.value = .episodes
            navigationView.leadingViewContainer.isHidden(false)
            navigationView.centerViewContainer.isHidden(true)
        } else {
            navigationView.viewModel.navigationViewState.value = .trailers
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
    func viewDidLoad()
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
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        addSubview(view)
        return view
    }()
    
    fileprivate lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle(viewModel.title, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        addSubview(view)
        return view
    }()
    
    var isSelected = false
    var widthConstraint: NSLayoutConstraint!
    
    deinit {
        widthConstraint = nil
        configuration = nil
        viewModel = nil
    }
    
    static func create(on parent: UIView,
                       navigationView: DetailNavigationView) -> DetailNavigationViewItem {
        let view = DetailNavigationViewItem(frame: parent.bounds)
        view.tag = parent.tag
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        createViewModel(on: view)
        createConfiguration(on: view, with: navigationView)
        view.viewDidLoad()
        return view
    }
    
    @discardableResult
    private static func createViewModel(on view: DetailNavigationViewItem) -> DetailNavigationViewItemViewModel {
        view.viewModel = .init(with: view)
        return view.viewModel
    }
    
    @discardableResult
    private static func createConfiguration(on view: DetailNavigationViewItem,
                                            with navigationView: DetailNavigationView) -> DetailNavigationViewItemConfiguration {
        view.configuration = .create(on: view, with: navigationView)
        return view.configuration
    }
    
    fileprivate func viewDidLoad() { setupSubviews() }
    
    private func setupSubviews() {
        widthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: bounds.width)
        chainConstraintToSuperview(linking: indicatorView,
                                   to: button,
                                   withWidthAnchor: widthConstraint)
    }
}
