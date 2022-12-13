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
}

private typealias Configuration = ConfigurationInput & ConfigurationOutput

final class NavigationViewItemConfiguration: Configuration {
    fileprivate weak var item: NavigationViewItem!
    
    init(configurationWithItem item: NavigationViewItem) {
        self.item = item
        self.viewDidLoad()
    }
    
    deinit {
        item = nil
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
        guard
            let navigation = item.viewModel.coordinator.viewController?.navigationView,
            let state = NavigationView.State(rawValue: item.tag)
        else { return }
        
        let tabBar = Application.current.coordinator.window?.rootViewController as! TabBarController
        
        AsyncImageFetcher.shared.cache.removeAllObjects()
        
        if var _ = item.viewModel.coordinator.viewController?.dataSource {
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.removeObservers()
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.viewModel?.myList?.removeObservers()
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.viewModel?.removeObservers()
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.viewModel?.removeObservers()
            
            item?.viewModel?.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.configuration?.tapRecognizer = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.configuration?.longPressRecognizer = nil
            item?.viewModel?.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.configuration?.view = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.configuration = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.viewModel = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView?.removeFromSuperview()
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.leadingItemView = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.configuration.longPressRecognizer = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.configuration.tapRecognizer = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.configuration?.view = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.configuration = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.viewModel = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView?.removeFromSuperview()
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.trailingItemView = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.viewModel = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.removeObservers()
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView?.removeFromSuperview()
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.panelView = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.configuration = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.viewModel = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView?.removeFromSuperview()
            item.viewModel.coordinator.viewController?.dataSource?.displayCell?.displayView = nil
            item.viewModel.coordinator.viewController?.dataSource?.displayCell = nil
            
            item.viewModel.coordinator.viewController?.dataSource?.tableView.removeFromSuperview()
            item.viewModel.coordinator.viewController?.dataSource?.tableView.delegate = nil
            item.viewModel.coordinator.viewController?.dataSource?.tableView.dataSource = nil
            item.viewModel.coordinator.viewController?.dataSource?.tableView = nil
            item.viewModel.coordinator.viewController?.dataSource = nil
            item.viewModel.coordinator.viewController?.tableView?.delegate = nil
            item.viewModel.coordinator.viewController?.tableView?.dataSource = nil
            item.viewModel.coordinator.viewController?.tableView?.removeFromSuperview()
            item.viewModel.coordinator.viewController?.tableView = nil
            
            item.viewModel.coordinator.viewController?.navigationView.removeObservers()
            item.viewModel.coordinator.viewController?.navigationView.removeFromSuperview()
            item.viewModel.coordinator.viewController?.navigationView = nil
            
            item.viewModel.coordinator.viewController?.categoriesOverlayView.removeObservers()
            item.viewModel.coordinator.viewController?.categoriesOverlayView.removeFromSuperview()
            item.viewModel.coordinator.viewController?.categoriesOverlayView = nil
            
            item.viewModel.coordinator.viewController?.browseOverlayView.removeFromSuperview()
            item.viewModel.coordinator.viewController?.browseOverlayView = nil
            
            item.viewModel.coordinator.viewController?.viewModel?.myList?.removeObservers()
            item.viewModel.coordinator.viewController?.viewModel?.coordinator = nil
            item.viewModel.coordinator.viewController?.viewModel?.mediaTask = nil
            item.viewModel.coordinator.viewController?.viewModel?.sectionsTask = nil
            item.viewModel.coordinator.viewController?.viewModel?.tableViewState = nil
            item.viewModel.coordinator.viewController?.viewModel?.myList = nil
            item.viewModel.coordinator.viewController?.viewModel = nil
            
            item.viewModel.coordinator.viewController?.removeObservers()
            item.viewModel.coordinator.viewController?.removeFromParent()
            
            item.viewModel.coordinator.viewController = nil
            
            tabBar.viewModel.coordinator = nil
            
            Application.current.coordinator.viewController = nil
        }
        
        asynchrony(dispatchingDelayInSeconds: 1) {
            if state == .home {
                Application.current.coordinator.showScreen(.tabBar, .all)
            } else if state == .tvShows {
                Application.current.coordinator.showScreen(.tabBar, .series)
            } else if state == .movies {
                Application.current.coordinator.showScreen(.tabBar, .films)
            } else {}
        }
    }
}

final class NavigationViewItem: UIView {
    fileprivate(set) lazy var button = UIButton(type: .system)
    
    private(set) var configuration: NavigationViewItemConfiguration!
    var viewModel: NavigationViewItemViewModel!
    
    init(onParent parent: UIView, with viewModel: HomeViewModel) {
        super.init(frame: parent.bounds)
        self.tag = parent.tag
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.viewModel = .init(tag: self.tag, with: viewModel)
        self.configuration = .init(configurationWithItem: self)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        print("NavigationViewItem")
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
