//
//  NavigationItemView.swift
//  netflix
//
//  Created by Zach Bazov on 17/09/2022.
//

import UIKit

// MARK: - NavigationViewItemConfiguration protocol

@objc
private protocol NavigationViewItemConfiguration {
    func itemDidConfigure(item: NavigationViewItemView)
    func _buttonDidTap()
}

// MARK: - DefaultNavigationViewItemConfiguration class

final class DefaultNavigationViewItemConfiguration: NavigationViewItemConfiguration {
    
    private weak var item: NavigationViewItemView!
    var buttonDidTap: ((DefaultNavigationView.State) -> Void)?
    
    deinit {
        item = nil
        buttonDidTap = nil
    }
    
    static func create(with item: NavigationViewItemView) -> DefaultNavigationViewItemConfiguration {
        let configuration = DefaultNavigationViewItemConfiguration()
        configuration.itemDidConfigure(item: item)
        return configuration
    }
    
    fileprivate func itemDidConfigure(item: NavigationViewItemView) {
        self.item = item
        
        guard let state = DefaultNavigationView.State(rawValue: item.tag) else { return }
        
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
            item.button.titleLabel?.tintColor = .white
            item.button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
            item.button.setTitle(item.viewModel.title, for: .normal)
        }
    }
    
    fileprivate func _buttonDidTap() {
        guard let state = DefaultNavigationView.State(rawValue: item.tag) else { return }
        buttonDidTap?(state)
    }
}

// MARK: - NavigationViewItemView class

final class NavigationViewItemView: UIView {
    
    fileprivate lazy var button: UIButton = { return UIButton(type: .system) }()
    
    private(set) var configuration: DefaultNavigationViewItemConfiguration!
    fileprivate var viewModel: DefaultNavigationViewItemViewViewModel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = .init(tag: self.tag)
        self.configuration = .create(with: self)
    }
    
    deinit {
        configuration = nil
        viewModel = nil
    }
}
