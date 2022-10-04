//
//  DetailPanelViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 04/10/2022.
//

import UIKit

// MARK: - ItemConfiguration protocol

@objc
private protocol ItemConfiguration {
    func itemDidConfigure(item: DetailPanelViewItem)
    func buttonDidTap()
}

// MARK: - DetailPanelViewItemConfiguration class

final class DetailPanelViewItemConfiguration: ItemConfiguration {
    
    enum Item: Int {
        case myList
        case rate
        case share
    }
    
    private weak var item: DetailPanelViewItem!
    
    init(item: DetailPanelViewItem) { self.item = item }
    
    deinit { item = nil }
    
    static func create(with item: DetailPanelViewItem) -> DetailPanelViewItemConfiguration {
        let configuration = DetailPanelViewItemConfiguration(item: item)
        configuration.itemDidConfigure(item: item)
        return configuration
    }
    
    func itemDidConfigure(item: DetailPanelViewItem) {
        let tapRecognizer = UITapGestureRecognizer(target: self,
                                                   action: #selector(buttonDidTap))
        item.addGestureRecognizer(tapRecognizer)
        item.imageView.image = UIImage(systemName: item.viewModel.systemImage)?.whiteRendering()
        item.label.text = item.viewModel.title
    }
    
    func buttonDidTap() {
        guard let tag = Item(rawValue: item.tag) else { return }
        switch tag {
        case .myList:
            print("mylist")
        case .rate:
            print("rate")
        case .share:
            print("share")
        }
    }
}

// MARK: - DetailPanelViewItem class

final class DetailPanelViewItem: UIView {
    
    private var configuration: DetailPanelViewItemConfiguration?
    
    private(set) var viewModel: DetailPanelViewItemViewModel!
    
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
    
    static func create(on parent: UIView) -> DetailPanelViewItem {
        let view = DetailPanelViewItem(frame: parent.bounds)
        view.tag = parent.tag
        view.viewModel = DetailPanelViewItemViewModel(tag: view.tag)
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
