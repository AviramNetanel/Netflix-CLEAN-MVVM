//
//  DetailPanelView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure()
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
    
    init(on parent: UIView, with viewModel: DetailViewModel) {
        super.init(frame: parent.bounds)
        self.nibDidLoad()
        self.leadingItem = DetailPanelViewItem(on: self.leadingViewContainer, with: viewModel)
        self.centerItem = DetailPanelViewItem(on: self.centerViewContainer, with: viewModel)
        self.trailingItem = DetailPanelViewItem(on: self.trailingViewContainer, with: viewModel)
        self.viewDidConfigure()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    fileprivate func viewDidConfigure() {
        backgroundColor = .black
    }
}
