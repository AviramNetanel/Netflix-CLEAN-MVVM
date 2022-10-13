//
//  PanelViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - ItemConfiguration protocol

@objc
private protocol ItemConfiguration {
    func recognizersDidRegister()
    func itemDidConfigure()
    func buttonDidTap()
    func buttonDidLongPress()
}

// MARK: - PanelViewItemConfiguration class

final class PanelViewItemConfiguration: NSObject, ItemConfiguration {
    
    enum GestureGecognizer {
        case tap
        case longPress
    }
    
    private weak var item: PanelViewItem!
    private let gestureRecognizers: [GestureGecognizer]
    
    private var tapRecognizer: UITapGestureRecognizer!
    private var longPressRecognizer: UILongPressGestureRecognizer!
    
    init(item: PanelViewItem, gestureRecognizers: [GestureGecognizer]) {
        self.item = item
        self.gestureRecognizers = gestureRecognizers
        super.init()
        self.recognizersDidRegister()
        self.itemDidConfigure()
    }
    
    deinit {
        item = nil
        tapRecognizer = nil
        longPressRecognizer = nil
    }
    
    func recognizersDidRegister() {
        if gestureRecognizers.contains(.tap) {
            tapRecognizer = .init(target: self, action: #selector(buttonDidTap))
            item.addGestureRecognizer(tapRecognizer)
        }
        if gestureRecognizers.contains(.longPress) {
            longPressRecognizer = .init(target: self, action: #selector(buttonDidLongPress))
            item.addGestureRecognizer(longPressRecognizer)
        }
    }
    
    func itemDidConfigure() {
        guard let item = item else { return }
        item.imageView.image = .init(systemName: item.viewModel.systemImage)
        item.titleLabel.text = item.viewModel.title
    }
    
    @objc
    func buttonDidTap() {
        item.setAlphaAnimation(using: item.gestureRecognizers!.first)
        item.viewModel.isSelected.value.toggle()
    }
    
    @objc
    func buttonDidLongPress() {}
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    var isSelected: Bool { get }
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - PanelViewItem class

final class PanelViewItem: UIView, View, ViewInstantiable {
    
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var imageView: UIImageView!
    
    var isSelected = false
    
    private(set) var configuration: PanelViewItemConfiguration!
    private(set) var viewModel: PanelViewItemViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.nibDidLoad()
        self.viewModel = .init(with: self)
        self.configuration = .init(item: self, gestureRecognizers: [.tap])
    }
    
    deinit {
        configuration = nil
        viewModel = nil
    }
}
