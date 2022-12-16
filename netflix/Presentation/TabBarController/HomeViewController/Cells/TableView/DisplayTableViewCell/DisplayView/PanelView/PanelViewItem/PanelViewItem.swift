//
//  PanelViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

@objc
private protocol ConfigurationInput {
    func viewDidRegisterRecognizers()
    func viewDidConfigure()
    func viewDidTap()
    func viewDidLongPress()
    func selectIfNeeded()
}

private protocol ConfigurationOutput {
    var view: PanelViewItem? { get }
    var viewModel: DisplayTableViewCellViewModel { get }
    var gestureRecognizers: [PanelViewItemConfiguration.GestureGecognizer] { get }
    var tapRecognizer: UITapGestureRecognizer! { get }
    var longPressRecognizer: UILongPressGestureRecognizer! { get }
}

private typealias Configuration = ConfigurationInput & ConfigurationOutput

final class PanelViewItemConfiguration: Configuration {
    enum GestureGecognizer {
        case tap
        case longPress
    }
    
    enum Item: Int {
        case myList
        case info
    }
    
    weak var view: PanelViewItem?
    fileprivate var viewModel: DisplayTableViewCellViewModel
    fileprivate var gestureRecognizers: [GestureGecognizer]
    var tapRecognizer: UITapGestureRecognizer!
    var longPressRecognizer: UILongPressGestureRecognizer!
    
    init(view: PanelViewItem,
         gestureRecognizers: [GestureGecognizer],
         with viewModel: DisplayTableViewCellViewModel) {
        self.viewModel = viewModel
        self.view = view
        self.gestureRecognizers = gestureRecognizers
        self.viewDidRegisterRecognizers()
        self.viewDidConfigure()
    }
    
    deinit {
        view?.removeFromSuperview()
        view = nil
        tapRecognizer = nil
        longPressRecognizer = nil
    }
    
    fileprivate func viewDidRegisterRecognizers() {
        if gestureRecognizers.contains(.tap) {
            tapRecognizer = .init(target: self, action: #selector(viewDidTap))
            view?.addGestureRecognizer(tapRecognizer)
        }
        if gestureRecognizers.contains(.longPress) {
            longPressRecognizer = .init(target: self, action: #selector(viewDidLongPress))
            view?.addGestureRecognizer(longPressRecognizer)
        }
    }
    
    fileprivate func selectIfNeeded() {
        guard
            let view = view,
            let item = Item(rawValue: view.tag)
        else { return }
        if case .myList = item {
            guard let myList = viewModel.myList else { return }
            view.viewModel.isSelected.value = myList.viewModel.contains(
                view.viewModel.media,
                in: viewModel.sectionAt(.myList).media)
        }
    }
    
    func viewDidConfigure() {
        guard let view = view else { return }
        guard let viewModel = view.viewModel else { return }
        view.imageView.image = .init(systemName: viewModel.systemImage)
        view.titleLabel.text = viewModel.title
        
        
        selectIfNeeded()
    }
    
    @objc
    func viewDidTap() {
        guard
            let view = view,
            let tag = Item(rawValue: view.tag)
        else { return }
        switch tag {
        case .myList:
            if viewModel.myList!.viewModel.list.value.isEmpty {
                viewModel.myList?.viewModel.createList()
            }
            
            let media = viewModel.presentedDisplayMedia.value!
            viewModel.myList?.viewModel.shouldAddOrRemove(media, uponSelection: view.viewModel.isSelected.value)
        case .info:
            let section = viewModel.sectionAt(.resumable)
            let media = viewModel.presentedDisplayMedia.value!
            viewModel.actions?.presentMediaDetails(section, media, false)
        }
        
        view.setAlphaAnimation(using: view.gestureRecognizers!.first) {
            view.viewModel.isSelected.value.toggle()
        }
    }
    
    @objc
    func viewDidLongPress() {}
}

final class PanelViewItem: UIView, ViewInstantiable {
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var imageView: UIImageView!
    
    var configuration: PanelViewItemConfiguration!
    var viewModel: PanelViewItemViewModel!
    fileprivate(set) var isSelected = false
    
    init(on parent: UIView, with viewModel: DisplayTableViewCellViewModel) {
        super.init(frame: parent.bounds)
        self.nibDidLoad()
        self.tag = parent.tag
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.viewModel = PanelViewItemViewModel(item: self, with: viewModel.presentedDisplayMedia.value!)
        self.configuration = PanelViewItemConfiguration(view: self, gestureRecognizers: [.tap], with: viewModel)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        configuration.view = nil
        configuration = nil
        viewModel = nil
    }
}
