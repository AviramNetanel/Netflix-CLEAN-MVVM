//
//  DetailPanelViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - ConfigurationInput protocol

@objc
private protocol ConfigurationInput {
    func viewDidConfigure()
    func buttonDidTap()
}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - DetailPanelViewItemConfiguration class

final class DetailPanelViewItemConfiguration: Configuration {
    
    enum Item: Int {
        case myList
        case rate
        case share
    }
    
    private weak var view: DetailPanelViewItem!
    
    init(view: DetailPanelViewItem) { self.view = view }
    
    deinit { view = nil }
    
    static func create(with item: DetailPanelViewItem) -> DetailPanelViewItemConfiguration {
        let configuration = DetailPanelViewItemConfiguration(view: item)
        configuration.viewDidConfigure()
        let tapRecognizer = UITapGestureRecognizer(target: configuration,
                                                   action: #selector(configuration.buttonDidTap))
        item.addGestureRecognizer(tapRecognizer)
        return configuration
    }
    
    func viewDidConfigure() {
        view.imageView.image = UIImage(systemName: view.viewModel.systemImage)?.whiteRendering()
        view.label.text = view.viewModel.title
    }
    
    func buttonDidTap() {
        guard let tag = Item(rawValue: view.tag) else { return }
        
        view.setAlphaAnimation(using: view.gestureRecognizers!.first)
        view.viewModel.isSelected.value.toggle()
        
        switch tag {
        case .myList: print("mylist")
        case .rate: print("rate")
        case .share: print("share")
        }
    }
}

// MARK: - DetailPanelViewItem class

final class DetailPanelViewItem: UIView {
    
    private(set) var configuration: DetailPanelViewItemConfiguration?
    var viewModel: DetailPanelViewItemViewModel!
    
    fileprivate lazy var imageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.image = image.whiteRendering()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        return label
    }()
    
    var isSelected = false
    
    static func create(on parent: UIView) -> DetailPanelViewItem {
        let view = DetailPanelViewItem(frame: parent.bounds)
        view.tag = parent.tag
        view.viewModel = DetailPanelViewItemViewModel(with: view)
        view.configuration = .create(with: view)
        view.setupSubviews()
        return view
    }
    
    private func setupSubviews() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 24.0),
            imageView.heightAnchor.constraint(equalToConstant: 24.0),
            imageView.bottomAnchor.constraint(equalTo: label.topAnchor, constant: 0.0),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8.0)
        ])
    }
}
