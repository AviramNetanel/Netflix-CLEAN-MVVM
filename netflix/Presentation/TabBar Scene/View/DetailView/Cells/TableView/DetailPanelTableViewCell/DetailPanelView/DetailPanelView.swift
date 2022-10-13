//
//  DetailPanelView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {}

// MARK: - ViewOutput protocol

private protocol ViewOutput {}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailPanelView class

final class DetailPanelView: UIView, View, ViewInstantiable {
    
    @IBOutlet private weak var leadingViewContainer: UIView!
    @IBOutlet private weak var centerViewContainer: UIView!
    @IBOutlet private weak var trailingViewContainer: UIView!
    
    private(set) var leadingItem: DetailPanelViewItem!
    private(set) var centerItem: DetailPanelViewItem!
    private(set) var trailingItem: DetailPanelViewItem!
    
    static func create(on parent: UIView) -> DetailPanelView {
        let view = DetailPanelView(frame: parent.bounds)
        view.nibDidLoad()
        view.backgroundColor = .black
        view.setupSubviews()
        return view
    }
    
    private func setupSubviews() {
        setupLeadingView()
        setupCenterView()
        setupTrailingView()
    }
    
    private func setupLeadingView() {
        leadingItem = DetailPanelViewItem.create(on: leadingViewContainer)
        leadingViewContainer.addSubview(leadingItem)
    }
    
    private func setupCenterView() {
        centerItem = DetailPanelViewItem.create(on: centerViewContainer)
        centerViewContainer.addSubview(centerItem)
    }
    
    private func setupTrailingView() {
        trailingItem = DetailPanelViewItem.create(on: trailingViewContainer)
        trailingViewContainer.addSubview(trailingItem)
    }
}
