//
//  PanelView.swift
//  netflix
//
//  Created by Zach Bazov on 10/09/2022.
//

import UIKit

// MARK: - PanelViewDependencies protocol

protocol PanelViewDependencies {
    func createPanelView(on view: DisplayView, with viewModel: DisplayTableViewCellViewModel) -> PanelView
    func createPanelViewItemViewModel(on view: PanelViewItem, with viewModel: DisplayTableViewCellViewModel) -> PanelViewItemViewModel
    func createPanelViewItemConfiguration(on view: PanelViewItem, with viewModel: DisplayTableViewCellViewModel) -> PanelViewItemConfiguration
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var leadingItemView: PanelViewItem! { get }
    var trailingItemView: PanelViewItem! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - PanelView class

final class PanelView: UIView, View, ViewInstantiable {
    
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private(set) weak var leadingItemViewContainer: UIView!
    @IBOutlet private(set) weak var trailingItemViewContainer: UIView!
    
    fileprivate(set) var leadingItemView: PanelViewItem!
    fileprivate(set) var trailingItemView: PanelViewItem!
    
    init(using diProvider: HomeViewDIProvider,
         on parent: UIView,
         with viewModel: DisplayTableViewCellViewModel) {
        super.init(frame: parent.bounds)
        self.nibDidLoad()
        parent.addSubview(self)
        self.constraintToSuperview(parent)
        self.leadingItemView = PanelViewItem(using: diProvider, on: self.leadingItemViewContainer, with: viewModel)
        self.trailingItemView = PanelViewItem(using: diProvider, on: self.trailingItemViewContainer, with: viewModel)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        leadingItemView = nil
        trailingItemView = nil
    }
    
    fileprivate func viewDidConfigure() {
        playButton.layer.cornerRadius = 6.0
    }
    
    func removeObservers() {
        printIfDebug("Removed `PanelView` observers.")
        leadingItemView.viewModel.removeObservers()
        trailingItemView.viewModel.removeObservers()
    }
}
