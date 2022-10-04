//
//  NavigationViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 17/09/2022.
//

import UIKit

// MARK: - ItemConfiguration protocol

@objc
private protocol ItemConfiguration {
    func itemDidConfigure(item: NavigationViewItem)
    func _buttonDidTap()
}

// MARK: - NavigationViewItemConfiguration class

final class NavigationViewItemConfiguration: ItemConfiguration {
    
    private weak var item: NavigationViewItem!
    var buttonDidTap: ((NavigationView.State) -> Void)?
    
    deinit {
        item = nil
        buttonDidTap = nil
    }
    
    static func create(with item: NavigationViewItem) -> NavigationViewItemConfiguration {
        let configuration = NavigationViewItemConfiguration()
        configuration.itemDidConfigure(item: item)
        return configuration
    }
    
    fileprivate func itemDidConfigure(item: NavigationViewItem) {
        self.item = item
        
        guard let state = NavigationView.State(rawValue: item.tag) else { return }
        
        item.addSubview(item.button)
        item.button.frame = item.bounds
        item.button.layer.shadow(.black, radius: 3.0, opacity: 0.4)
        item.button.addTarget(self,
                              action: #selector(_buttonDidTap),
                              for: .touchUpInside)
        
        let image: UIImage!
        let symbolConfiguration: UIImage.SymbolConfiguration!
        switch state {
        case .home:
            image = UIImage(named: item.viewModel.image)?
                .withRenderingMode(.alwaysOriginal)
            item.button.setImage(image, for: .normal)
        case .airPlay:
            symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 16.0)
            image = UIImage(systemName: item.viewModel.image)?
                .whiteRendering(with: symbolConfiguration)
            item.button.setImage(image, for: .normal)
        case .account:
            symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 17.0)
            image = UIImage(systemName: item.viewModel.image)?
                .whiteRendering(with: symbolConfiguration)
            item.button.setImage(image, for: .normal)
        default:
            item.button.setTitleColor(.white, for: .normal)
            item.button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
            item.button.setTitle(item.viewModel.title, for: .normal)
        }
    }
    
    fileprivate func _buttonDidTap() {
        guard let state = NavigationView.State(rawValue: item.tag) else { return }
        buttonDidTap?(state)
    }
}

// MARK: - NavigationViewItem class

final class NavigationViewItem: UIView {
    
    fileprivate(set) lazy var button: UIButton = { return UIButton(type: .system) }()
    
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
    
    func configure(with state: NavigationView.State) {
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
            switch tag {
            case .categories:
                button.setTitle("All \(viewModel.title!)", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
            default: break
            }
        default: break
        }
    }
}
