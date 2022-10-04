//
//  DetailNavigationViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - ItemConfiguration protocol

@objc
private protocol ItemConfiguration {
    func itemDidConfigure(item: DetailNavigationViewItem)
    func buttonDidTap()
}

// MARK: - DetailNavigationViewItemConfiguration class

final class DetailNavigationViewItemConfiguration: ItemConfiguration {
    
    private weak var item: DetailNavigationViewItem!
    
    init(item: DetailNavigationViewItem) {
        self.item = item
        self.itemDidConfigure(item: self.item)
    }
    
    deinit { item = nil }
    
    func itemDidConfigure(item: DetailNavigationViewItem) {
        item.button.addTarget(self,
                              action: #selector(buttonDidTap),
                              for: .touchUpInside)
    }
    
    func buttonDidTap() {
        guard let tag = DetailNavigationViewItem.Item(rawValue: item.tag) else { fatalError() }
        switch tag {
        case .episodes: print("episodes")
        case .trailers: print("trailers")
        case .similarContent: print("similarContent")
        }
    }
}

// MARK: - DetailNavigationViewItem class

final class DetailNavigationViewItem: UIView {
    
    enum Item: Int {
        case episodes
        case trailers
        case similarContent
    }
    
    private var configuration: DetailNavigationViewItemConfiguration!
    
    private var viewModel: DetailNavigationViewItemViewModel!
    
    private lazy var indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }()
    
    fileprivate lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle(viewModel.title, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }()
    
    static func create(on parent: UIView) -> DetailNavigationViewItem {
        let view = DetailNavigationViewItem(frame: parent.bounds)
        view.tag = parent.tag
        view.viewModel = .init(tag: view.tag)
        view.configuration = .init(item: view)
        view.setupSubviews()
        return view
    }
    
    deinit {
        configuration = nil
        viewModel = nil
    }
    
    private func setupSubviews() {
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 4.0),
            indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            indicatorView.heightAnchor.constraint(equalToConstant: 3.0),
            button.topAnchor.constraint(equalTo: indicatorView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: indicatorView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: indicatorView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
