//
//  DisplayView.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - DisplayView class

final class DisplayView: UIView, Reusable {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var typeImageView: UIImageView!
    
    private var panelView: PanelView!
    private var viewModel: DefaultHomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    deinit {
        bottomGradientView = nil
        panelView = nil
        viewModel = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: DefaultHomeViewModel) -> DisplayView {
        let displayView = DisplayView.nib.instantiateSubview(onParent: parent) as! DisplayView
        displayView.viewModel = viewModel
        displayView.panelView = PanelView.create(on: displayView, with: viewModel)
        return displayView
    }
    
    private func setupViews() {
        bottomGradientView.addGradientLayer(frame: bottomGradientView.bounds,
                                            colors: [.clear, .black],
                                            locations: [0.0, 0.66])
    }
}
