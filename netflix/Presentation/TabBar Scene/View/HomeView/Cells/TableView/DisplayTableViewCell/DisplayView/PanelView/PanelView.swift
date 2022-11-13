//
//  PanelView.swift
//  netflix
//
//  Created by Zach Bazov on 10/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
    func viewDidUnobserve()
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
    @IBOutlet private weak var leadingItemViewContainer: UIView!
    @IBOutlet private weak var trailingItemViewContainer: UIView!
    
    fileprivate var leadingItemView: PanelViewItem!
    fileprivate var trailingItemView: PanelViewItem!
    
    deinit {
        leadingItemView = nil
        trailingItemView = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: HomeViewModel) -> PanelView {
        let view = PanelView(frame: parent.bounds)
        view.nibDidLoad()
        parent.addSubview(view)
        view.constraintToSuperview(parent)
        createItems(on: view, with: viewModel)
        view.viewDidLoad()
        return view
    }
    
    private static func createItems(on view: PanelView,
                                    with viewModel: HomeViewModel) {
        view.leadingItemView = .create(on: view.leadingItemViewContainer, with: viewModel)
        view.trailingItemView = .create(on: view.trailingItemViewContainer, with: viewModel)
    }
    
    fileprivate func viewDidLoad() { viewDidConfigure() }
    
    fileprivate func viewDidConfigure() { playButton.layer.cornerRadius = 6.0 }
    
    func viewDidUnobserve() {
        printIfDebug("Removed `PanelView` observers.")
        leadingItemView.viewModel.removeObservers()
        trailingItemView.viewModel.removeObservers()
    }
}
