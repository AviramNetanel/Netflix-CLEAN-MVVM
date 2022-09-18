//
//  NavigationItemView.swift
//  netflix
//
//  Created by Zach Bazov on 17/09/2022.
//

import UIKit

// MARK: - NavigationItemViewConfiguration protocol

@objc
private protocol NavigationItemViewConfiguration {
    func itemDidConfigure(item: NavigationItemView)
    func _buttonDidTap()
}

// MARK: - DefaultNavigationItemViewConfiguration class

final class DefaultNavigationItemViewConfiguration: NavigationItemViewConfiguration {
    
    private weak var item: NavigationItemView!
    
    var buttonDidTap: ((DefaultNavigationView.State) -> Void)?
    
    deinit {
        item = nil
        buttonDidTap = nil
    }
    
    static func create(with item: NavigationItemView) -> DefaultNavigationItemViewConfiguration {
        let configuration = DefaultNavigationItemViewConfiguration()
        configuration.itemDidConfigure(item: item)
        return configuration
    }
    
    fileprivate func itemDidConfigure(item: NavigationItemView) {
        self.item = item
        item.button.setTitle(item.viewModel.title, for: .normal)
        item.button.addTarget(self,
                              action: #selector(_buttonDidTap),
                              for: .touchUpInside)
        
//        if item.tag == 0 {
//            let image = UIImage(named: item.viewModel.image)?.withRenderingMode(.alwaysOriginal)
//            item.button.setImage(image, for: .normal)
//        }
    }
    
    fileprivate func _buttonDidTap() {
        guard let state = DefaultNavigationView.State(rawValue: item.tag) else { return }
        buttonDidTap?(state)
    }
}

// MARK: - NavigationItemView class

final class NavigationItemView: UIView, ViewInstantiable {
    
    @IBOutlet weak var button: UIButton!
    
    private(set) var configuration: DefaultNavigationItemViewConfiguration!
    fileprivate var viewModel: DefaultNavigationItemViewViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nibDidLoad()
        self.viewModel = .init(tag: self.tag)
        self.configuration = .create(with: self)
    }
    
    deinit {
        configuration = nil
        viewModel = nil
    }
}
