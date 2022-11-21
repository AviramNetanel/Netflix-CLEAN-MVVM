//
//  DetailPanelView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var leadingItem: DetailPanelViewItem! { get }
    var centerItem: DetailPanelViewItem! { get }
    var trailingItem: DetailPanelViewItem! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailPanelView class

final class DetailPanelView: UIView, View, ViewInstantiable {
    
    @IBOutlet private weak var leadingViewContainer: UIView!
    @IBOutlet private weak var centerViewContainer: UIView!
    @IBOutlet private weak var trailingViewContainer: UIView!
    
    fileprivate(set) var leadingItem: DetailPanelViewItem!
    fileprivate(set) var centerItem: DetailPanelViewItem!
    fileprivate(set) var trailingItem: DetailPanelViewItem!
    
    static func create(on parent: UIView,
                       viewModel: DetailViewModel) -> DetailPanelView {
        let view = DetailPanelView(frame: parent.bounds)
        view.nibDidLoad()
        createItems(on: view, viewModel: viewModel)
        view.viewDidLoad()
        return view
    }
    
    private static func createItems(on view: DetailPanelView,
                                    viewModel: DetailViewModel) {
        view.leadingItem = .create(on: view.leadingViewContainer,
                                   viewModel: viewModel)
        view.centerItem = .create(on: view.centerViewContainer,
                                  viewModel: viewModel)
        view.trailingItem = .create(on: view.trailingViewContainer,
                                    viewModel: viewModel)
    }
    
    fileprivate func viewDidLoad() { setupSubviews() }
    
    private func setupSubviews() { backgroundColor = .black }
}
