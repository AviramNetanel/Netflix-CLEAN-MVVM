//
//  NavigationViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 17/09/2022.
//

import UIKit

// MARK: - ConfigurationInput protocol

@objc
private protocol ConfigurationInput {
    func viewDidConfigure(view: NavigationViewItem)
    func viewDidTap()
}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {
    var view: NavigationViewItem! { get }
    var _viewDidTap: ((NavigationView.State) -> Void)? { get }
}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - NavigationViewItemConfiguration class

final class NavigationViewItemConfiguration: Configuration {
    
    fileprivate weak var view: NavigationViewItem!
    var _viewDidTap: ((NavigationView.State) -> Void)?
    
    deinit {
        view = nil
        _viewDidTap = nil
    }
    
    static func create(with view: NavigationViewItem) -> NavigationViewItemConfiguration {
        let configuration = NavigationViewItemConfiguration()
        configuration.viewDidConfigure(view: view)
        return configuration
    }
    
    fileprivate func viewDidConfigure(view: NavigationViewItem) {
        self.view = view
        
        guard let state = NavigationView.State(rawValue: view.tag) else { return }
        
        view.addSubview(view.button)
        view.button.frame = view.bounds
        view.button.layer.shadow(.black, radius: 3.0, opacity: 0.4)
        view.button.addTarget(self,
                              action: #selector(viewDidTap),
                              for: .touchUpInside)
        
        let image: UIImage!
        let symbolConfiguration: UIImage.SymbolConfiguration!
        switch state {
        case .home:
            image = UIImage(named: view.viewModel.image)?
                .withRenderingMode(.alwaysOriginal)
            view.button.setImage(image, for: .normal)
        case .airPlay:
            symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16.0)
            image = UIImage(systemName: view.viewModel.image)?
                .whiteRendering(with: symbolConfiguration)
            view.button.setImage(image, for: .normal)
        case .account:
            symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 17.0)
            image = UIImage(systemName: view.viewModel.image)?
                .whiteRendering(with: symbolConfiguration)
            view.button.setImage(image, for: .normal)
        default:
            view.button.setTitleColor(.white, for: .normal)
            view.button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
            view.button.setTitle(view.viewModel.title, for: .normal)
        }
    }
    
    fileprivate func viewDidTap() {
        guard let state = NavigationView.State(rawValue: view.tag) else { return }
        _viewDidTap?(state)
    }
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure(with state: NavigationView.State)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var configuration: NavigationViewItemConfiguration! { get }
    var viewModel: NavigationViewItemViewModel! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - NavigationViewItem class

final class NavigationViewItem: UIView, View {
    
    fileprivate(set) lazy var button: UIButton = { UIButton(type: .system) }()
    
    private(set) var configuration: NavigationViewItemConfiguration!
    var viewModel: NavigationViewItemViewModel!
    
    deinit {
        configuration = nil
        viewModel = nil
    }
    
    static func create(on parent: UIView) -> NavigationViewItem {
        let view = NavigationViewItem(frame: parent.bounds)
        view.tag = parent.tag
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        createViewModel(in: view)
        createConfiguration(in: view)
        return view
    }
    
    @discardableResult
    private static func createViewModel(in view: NavigationViewItem) -> NavigationViewItemViewModel {
        view.viewModel = .init(tag: view.tag)
        return view.viewModel
    }
    
    @discardableResult
    private static func createConfiguration(in view: NavigationViewItem) -> NavigationViewItemConfiguration {
        view.configuration = .create(with: view)
        return view.configuration
    }
    
    func viewDidConfigure(with state: NavigationView.State) {
        switch state {
        case .home:
            guard let tag = NavigationView.State(rawValue: tag) else { return }
            switch tag {
            case .categories:
                button.setTitle(viewModel.title, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
            default: break
            }
        case .tvShows,
                .movies:
            guard let tag = NavigationView.State(rawValue: tag) else { return }
            if case .categories = tag {
                button.setTitle("All \(viewModel.title!)", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
            }
        default: break
        }
    }
}
