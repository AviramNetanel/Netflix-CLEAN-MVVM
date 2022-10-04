//
//  DetailNavigationView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - DetailNavigationView class

final class DetailNavigationView: UIView, ViewInstantiable {
    
    @IBOutlet private weak var leadingViewContainer: UIView!
    @IBOutlet private weak var centerViewContainer: UIView!
    @IBOutlet private weak var trailingViewContrainer: UIView!
    
    static func create(on parent: UIView) -> DetailNavigationView {
        let view = DetailNavigationView(frame: parent.bounds)
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
        let view = DetailNavigationViewItem.create(on: leadingViewContainer)
        leadingViewContainer.addSubview(view)
    }
    
    private func setupCenterView() {
        let view = DetailNavigationViewItem.create(on: centerViewContainer)
        centerViewContainer.addSubview(view)
    }
    
    private func setupTrailingView() {
        let view = DetailNavigationViewItem.create(on: trailingViewContrainer)
        trailingViewContrainer.addSubview(view)
    }
}
