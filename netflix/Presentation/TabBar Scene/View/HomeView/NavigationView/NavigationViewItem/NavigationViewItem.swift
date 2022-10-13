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
    func buttonDidTap()
}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {
    var view: NavigationViewItem! { get }
    var _buttonDidTap: ((NavigationView.State) -> Void)? { get }
}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - NavigationViewItemConfiguration class

final class NavigationViewItemConfiguration: Configuration {
    
    fileprivate weak var view: NavigationViewItem!
    var _buttonDidTap: ((NavigationView.State) -> Void)?
    
    static func create(with view: NavigationViewItem) -> NavigationViewItemConfiguration {
        let configuration = NavigationViewItemConfiguration()
        configuration.viewDidConfigure(view: view)
        return configuration
    }
    
    deinit {
        view = nil
        _buttonDidTap = nil
    }
    
    fileprivate func viewDidConfigure(view: NavigationViewItem) {
        self.view = view
        
        guard let state = NavigationView.State(rawValue: view.tag) else { return }
        
        view.addSubview(view.button)
        view.button.frame = view.bounds
        view.button.layer.shadow(.black, radius: 3.0, opacity: 0.4)
        view.button.addTarget(self,
                              action: #selector(buttonDidTap),
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
    
    fileprivate func buttonDidTap() {
        guard let state = NavigationView.State(rawValue: view.tag) else { return }
        _buttonDidTap?(state)
    }
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure(with state: NavigationView.State)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var configuration: NavigationViewItemConfiguration! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - NavigationViewItem class

final class NavigationViewItem: UIView, View {
    
    fileprivate(set) lazy var button: UIButton = { UIButton(type: .system) }()
    
    private(set) var configuration: NavigationViewItemConfiguration!
    var viewModel: NavigationViewItemViewModel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = .init(tag: self.tag)
        self.configuration = .create(with: self)
    }
    
    deinit {
        configuration = nil
        viewModel = nil
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
