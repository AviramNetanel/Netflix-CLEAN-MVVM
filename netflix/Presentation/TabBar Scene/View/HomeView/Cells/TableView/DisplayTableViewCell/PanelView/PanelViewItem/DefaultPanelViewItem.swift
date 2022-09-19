//
//  DefaultPanelViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - PanelViewItemConfiguration protocol

@objc
private protocol PanelViewItemConfiguration {
    func recognizersDidRegister()
    func itemDidConfigure()
    func buttonDidTap()
    func buttonDidLongPress()
}

// MARK: - DefaultPanelViewItemConfiguration class

final class DefaultPanelViewItemConfiguration: NSObject, PanelViewItemConfiguration {
    
    enum GestureGecognizer {
        case tap
        case longPress
    }
    
    private weak var item: DefaultPanelViewItem!
    private let gestureRecognizers: [GestureGecognizer]
    
    private var tapRecognizer: UITapGestureRecognizer!
    private var longPressRecognizer: UILongPressGestureRecognizer!
    
    init(item: DefaultPanelViewItem, gestureRecognizers: [GestureGecognizer]) {
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
        item.viewModel.isSelected.value.toggle()
    }
    
    @objc
    func buttonDidLongPress() {}
}

// MARK: - PanelViewItemInput protocol

private protocol PanelViewItemInput {
    var isSelected: Bool { get }
}

// MARK: - PanelViewItemOutput protocol

private protocol PanelViewItemOutput {}

// MARK: - PanelViewItem protocol

private protocol PanelViewItem: PanelViewItemInput, PanelViewItemOutput {}

// MARK: - DefaultPanelViewItem class

final class DefaultPanelViewItem: UIView, PanelViewItem, ViewInstantiable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var isSelected = false
    
    var configuration: DefaultPanelViewItemConfiguration!
    var viewModel: DefaultPanelItemViewModel!
    
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
