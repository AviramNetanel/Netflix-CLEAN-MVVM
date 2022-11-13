//
//  PanelViewItem.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - ConfigurationInput protocol

@objc
private protocol ConfigurationInput {
    func viewDidRegisterRecognizers()
    func viewDidConfigure()
    func viewDidTap()
    func viewDidLongPress()
    func selectIfNeeded()
}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {
    var view: PanelViewItem! { get }
    var gestureRecognizers: [PanelViewItemConfiguration.GestureGecognizer]! { get }
    var tapRecognizer: UITapGestureRecognizer! { get }
    var longPressRecognizer: UILongPressGestureRecognizer! { get }
}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - PanelViewItemConfiguration class

final class PanelViewItemConfiguration: Configuration {
    
    enum GestureGecognizer {
        case tap
        case longPress
    }
    
    enum Item: Int {
        case myList
        case info
    }
    
    fileprivate weak var view: PanelViewItem!
    fileprivate var gestureRecognizers: [GestureGecognizer]!
    fileprivate var tapRecognizer: UITapGestureRecognizer!
    fileprivate var longPressRecognizer: UILongPressGestureRecognizer!
    
    static func create(view: PanelViewItem,
                       gestureRecognizers: [GestureGecognizer],
                       with viewModel: HomeViewModel) -> PanelViewItemConfiguration {
        let configuration = PanelViewItemConfiguration()
        configuration.view = view
        configuration.gestureRecognizers = gestureRecognizers
        configuration.viewDidRegisterRecognizers()
        configuration.viewDidConfigure()
        return configuration
    }
    
    deinit {
        view = nil
        gestureRecognizers = nil
        tapRecognizer = nil
        longPressRecognizer = nil
    }
    
    fileprivate func viewDidRegisterRecognizers() {
        if gestureRecognizers.contains(.tap) {
            tapRecognizer = .init(target: self, action: #selector(viewDidTap))
            view.addGestureRecognizer(tapRecognizer)
        }
        if gestureRecognizers.contains(.longPress) {
            longPressRecognizer = .init(target: self, action: #selector(viewDidLongPress))
            view.addGestureRecognizer(longPressRecognizer)
        }
    }
    
    fileprivate func selectIfNeeded() {
        guard let item = Item(rawValue: view.tag) else { return }
        if case .myList = item {
            view.viewModel.isSelected.value = view.homeViewModel.contains(
                view.viewModel.media,
                in: view.homeViewModel.section(at: .myList).media)
        }
    }
    
    func viewDidConfigure() {
        guard let view = view else { return }
        view.imageView.image = .init(systemName: view.viewModel.systemImage)
        view.titleLabel.text = view.viewModel.title
        
        selectIfNeeded()
    }
    
    @objc
    func viewDidTap() {
        guard let tag = Item(rawValue: view.tag) else { return }
        switch tag {
        case .myList:
            let media = view.homeViewModel.presentedDisplayMedia.value!
            if view.homeViewModel.myList.value.isEmpty {
                view.homeViewModel.myListDidCreate()
            }
            view.homeViewModel.shouldAddOrRemoveToMyList(
                media,
                uponSelection: view.viewModel.isSelected.value)
        case .info:
            let section = view.homeViewModel.section(at: .display)
            let media = view.homeViewModel.presentedDisplayMedia.value!
            view.homeViewModel.actions.presentMediaDetails(section, media)
        }
        
        view.setAlphaAnimation(using: view.gestureRecognizers!.first) { [weak self] in
            self?.view.viewModel.isSelected.value.toggle()
        }
    }
    
    @objc
    func viewDidLongPress() {}
}

// MARK: - ViewInput protocol

private protocol ViewInput {}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var configuration: PanelViewItemConfiguration! { get }
    var viewModel: PanelViewItemViewModel! { get }
    var homeViewModel: HomeViewModel! { get }
    var isSelected: Bool { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - PanelViewItem class

final class PanelViewItem: UIView, View, ViewInstantiable {
    
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var imageView: UIImageView!
    
    fileprivate(set) var configuration: PanelViewItemConfiguration!
    fileprivate(set) var viewModel: PanelViewItemViewModel!
    fileprivate var homeViewModel: HomeViewModel!
    fileprivate(set) var isSelected = false
    
    deinit {
        configuration = nil
        viewModel = nil
        homeViewModel = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: HomeViewModel) -> PanelViewItem {
        let view = PanelViewItem(frame: parent.bounds)
        view.nibDidLoad()
        view.tag = parent.tag
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        createViewModel(on: view, with: viewModel)
        createConfiguration(on: view)
        return view
    }
    
    @discardableResult
    private static func createViewModel(on view: PanelViewItem,
                                        with homeViewModel: HomeViewModel) -> PanelViewItemViewModel {
        let viewModel = PanelViewItemViewModel(item: view, with: homeViewModel.presentedDisplayMedia.value!)
        view.viewModel = viewModel
        view.homeViewModel = homeViewModel
        return viewModel
    }
    
    @discardableResult
    private static func createConfiguration(on view: PanelViewItem) -> PanelViewItemConfiguration {
        view.configuration = .create(view: view,
                                     gestureRecognizers: [.tap],
                                     with: view.homeViewModel)
        return view.configuration
    }
}
