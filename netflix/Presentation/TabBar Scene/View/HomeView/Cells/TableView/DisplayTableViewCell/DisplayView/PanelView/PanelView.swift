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
    func createPanelViewItems(on view: PanelView, with viewModel: DisplayTableViewCellViewModel)
    func createPanelViewItemViewModel(on view: PanelViewItem, with viewModel: DisplayTableViewCellViewModel) -> PanelViewItemViewModel
    func createPanelViewItemConfiguration(on view: PanelViewItem, with viewModel: DisplayTableViewCellViewModel) -> PanelViewItemConfiguration
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
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
    
    var leadingItemView: PanelViewItem!
    var trailingItemView: PanelViewItem!
    
    deinit {
        leadingItemView = nil
        trailingItemView = nil
    }
    
    static func create(on parent: UIView,
                       viewModel: DisplayTableViewCellViewModel,
                       homeSceneDependencies: HomeViewDIProvider) -> PanelView {
        let view = PanelView(frame: parent.bounds)
        view.nibDidLoad()
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        homeSceneDependencies.createPanelViewItems(on: view, with: viewModel)
        view.viewDidLoad()
        return view
    }
    
    fileprivate func viewDidLoad() { viewDidConfigure() }
    
    fileprivate func viewDidConfigure() { playButton.layer.cornerRadius = 6.0 }
    
    func removeObservers() {
        printIfDebug("Removed `PanelView` observers.")
        leadingItemView.viewModel.removeObservers()
        trailingItemView.viewModel.removeObservers()
    }
}
