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
    func buttonDidTap()
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
    
    init(view: DetailNavigationViewItem,
         with navigationView: DetailNavigationView) {
        self.view = view
        self.navigationView = navigationView
        self.view.button.addTarget(self,
                                   action: #selector(self.buttonDidTap),
                                   for: .touchUpInside)
    }
    
    deinit {
        view = nil
        navigationView = nil
    }
    
    func buttonDidTap() {
        if view.isSelected {
            view.widthConstraint?.constant = view.bounds.width
        } else {
            view.widthConstraint?.constant = .zero
        }
        
        view.isSelected.toggle()
        
        navigationView.stateDidChange(view: view)
    }
}

// MARK: - DetailNavigationViewItem class

final class DetailNavigationViewItem: UIView {
    
    enum Item: Int {
        case episodes
        case trailers
        case similarContent
    }
    
    private(set) var configuration: DetailNavigationViewItemConfiguration!
    private(set) var viewModel: DetailNavigationViewItemViewModel!
    
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
    
    var isSelected = false
    var widthConstraint: NSLayoutConstraint!
    
    static func create(on parent: UIView,
                       navigationView: DetailNavigationView) -> DetailNavigationViewItem {
        let view = DetailNavigationViewItem(frame: parent.bounds)
        view.tag = parent.tag
        view.viewModel = .init(with: view)
        view.configuration = .init(view: view, with: navigationView)
        view.setupSubviews()
        return view
    }
    
    deinit {
        widthConstraint = nil
        configuration = nil
        viewModel = nil
    }
    
    private func setupSubviews() {
        widthConstraint = indicatorView.widthAnchor.constraint(equalToConstant: bounds.width)
        NSLayoutConstraint.activate([
            indicatorView.topAnchor.constraint(equalTo: topAnchor, constant: 4.0),
            indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            widthConstraint,
            indicatorView.heightAnchor.constraint(equalToConstant: 3.0),
            button.topAnchor.constraint(equalTo: indicatorView.bottomAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
