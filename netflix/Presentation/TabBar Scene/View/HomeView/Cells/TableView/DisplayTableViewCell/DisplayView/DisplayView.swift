//
//  DisplayView.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - DisplayView class

final class DisplayView: UIView {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private weak var panelView: PanelView!
    
    private var viewModel: DefaultHomeViewModel!
    
    deinit {
        bottomGradientView = nil
        viewModel = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: DefaultHomeViewModel) -> DisplayView {
        let displayView = Bundle.main.loadNibNamed(String(describing: Self.self), owner: self, options: nil)![0] as! DisplayView
        displayView.frame = parent.bounds
        parent.addSubview(displayView)
        displayView.viewModel = viewModel
        displayView.setupViews()
        return displayView
    }
    
    private func setupViews() {
        bottomGradientView.addGradientLayer(frame: bottomGradientView.bounds,
                                            colors: [.clear, .black],
                                            locations: [0.0, 0.66])
    }
}
