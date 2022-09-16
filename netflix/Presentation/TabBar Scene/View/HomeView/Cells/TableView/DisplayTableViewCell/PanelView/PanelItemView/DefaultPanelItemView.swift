//
//  DefaultPanelItemView.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - PanelItemViewConfiguration protocol

@objc
private protocol PanelItemViewConfiguration {
    func recognizersDidRegister()
    func itemDidConfigure()
    func buttonDidTap()
    func buttonDidLongPress()
}

// MARK: - DefaultPanelItemViewConfiguration class

final class DefaultPanelItemViewConfiguration: NSObject, PanelItemViewConfiguration {
    
    enum GestureGecognizer {
        case tap
        case longPress
    }
    
    private weak var item: DefaultPanelItemView!
    private let gestureRecognizers: [GestureGecognizer]
    
    private var tapRecognizer: UITapGestureRecognizer!
    private var longPressRecognizer: UILongPressGestureRecognizer!
    
    init(item: DefaultPanelItemView, gestureRecognizers: [GestureGecognizer]) {
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

// MARK: - PanelItemViewInput protocol

private protocol PanelItemViewInput {
    var isSelected: Bool { get }
}

// MARK: - PanelItemViewOutput protocol

private protocol PanelItemViewOutput {}

// MARK: - PanelItemView protocol

private protocol PanelItemView: PanelItemViewInput, PanelItemViewOutput {}

// MARK: - DefaultPanelItemView class

final class DefaultPanelItemView: UIView, PanelItemView, ViewInstantiable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var isSelected = false
    
    var configuration: DefaultPanelItemViewConfiguration!
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
