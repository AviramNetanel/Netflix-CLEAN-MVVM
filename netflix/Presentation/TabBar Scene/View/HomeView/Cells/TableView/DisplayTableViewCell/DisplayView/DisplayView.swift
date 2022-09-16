//
//  DisplayView.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - DisplayView class

final class DisplayView: UIView, ViewInstantiable {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private(set) weak var panelView: PanelView!
    
    private var viewModel: DefaultHomeViewModel!
    
    deinit {
        bottomGradientView = nil
        viewModel = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: DefaultHomeViewModel) -> DisplayView {
        let displayView = DisplayView.instantiateSubview(onParent: parent) as! DisplayView
        displayView.viewModel = viewModel
        displayView.setupSubviews()
        return displayView
    }
    
    private func setupSubviews() {
        addGradientLayer()
    }
    
    private func addGradientLayer() {
        bottomGradientView.addGradientLayer(frame: bottomGradientView.bounds,
                                            colors: [.clear, .black],
                                            locations: [0.0, 0.66])
    }
}
