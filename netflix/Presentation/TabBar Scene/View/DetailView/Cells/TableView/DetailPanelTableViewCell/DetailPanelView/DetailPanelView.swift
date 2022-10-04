//
//  DetailPanelView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailPanelView class

final class DetailPanelView: UIView, ViewInstantiable {
    
    @IBOutlet private weak var leadingViewContainer: UIView!
    @IBOutlet private weak var centerViewContainer: UIView!
    @IBOutlet private weak var trailingViewContainer: UIView!
    
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
        let view = DetailPanelViewItem.create(on: leadingViewContainer)
        leadingViewContainer.addSubview(view)
    }
    
    private func setupCenterView() {
        let view = DetailPanelViewItem.create(on: centerViewContainer)
        centerViewContainer.addSubview(view)
    }
    
    private func setupTrailingView() {
        let view = DetailPanelViewItem.create(on: trailingViewContainer)
        trailingViewContainer.addSubview(view)
    }
}
