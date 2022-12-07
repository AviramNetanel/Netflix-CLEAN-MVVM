//
//  NavigationViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 17/09/2022.
//

import UIKit

@objc
private protocol ConfigurationInput {
    func viewDidLoad()
    func viewDidConfigure(item: NavigationViewItem)
    func viewDidTap()
}

private protocol ConfigurationOutput {
    var item: NavigationViewItem! { get }
    var _viewDidTap: ((NavigationView.State) -> Void)? { get }
}

private typealias Configuration = ConfigurationInput & ConfigurationOutput

final class NavigationViewItemConfiguration: Configuration {
    fileprivate weak var item: NavigationViewItem!
    var _viewDidTap: ((NavigationView.State) -> Void)?
    
    init(configurationWithItem item: NavigationViewItem) {
        self.item = item
        self.viewDidLoad()
    }
    
    deinit {
        item = nil
        _viewDidTap = nil
    }
    
    fileprivate func viewDidLoad() {
        viewDidConfigure(item: item)
    }
    
    fileprivate func viewDidConfigure(item: NavigationViewItem) {
        self.item = item
        
        guard let state = NavigationView.State(rawValue: item.tag) else { return }
        
        item.addSubview(item.button)
        item.button.frame = item.bounds
        item.button.layer.shadow(.black, radius: 3.0, opacity: 0.4)
        item.button.addTarget(self,
                              action: #selector(viewDidTap),
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
    
    fileprivate func viewDidTap() {
        guard let state = NavigationView.State(rawValue: item.tag) else { return }
        _viewDidTap?(state)
    }
}

final class NavigationViewItem: UIView {
    fileprivate(set) lazy var button = UIButton(type: .system)
    
    private(set) var configuration: NavigationViewItemConfiguration!
    var viewModel: NavigationViewItemViewModel!
    
    init(onParent parent: UIView) {
        super.init(frame: parent.bounds)
        self.tag = parent.tag
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.viewModel = .init(tag: self.tag)
        self.configuration = .init(configurationWithItem: self)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        configuration = nil
        viewModel = nil
    }
    
    func viewDidConfigure(with state: NavigationView.State) {
        guard let tag = NavigationView.State(rawValue: tag) else { return }
        if case .home = state,
           case .categories = tag {
            button.setTitle(viewModel.title, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        }
        if case .tvShows = state,
           case .categories = tag {
            button.setTitle("All \(viewModel.title!)", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        }
        if case .movies = state,
           case .categories = tag {
            button.setTitle("All \(viewModel.title!)", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        }
    }
}
