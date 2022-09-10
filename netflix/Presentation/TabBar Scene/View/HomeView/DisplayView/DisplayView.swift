//
//  DisplayView.swift
//  netflix
//
//  Created by Zach Bazov on 09/09/2022.
//

import UIKit

// MARK: - DisplayView class

final class DisplayView: UIView {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    
    private var panelView: PanelView!
    private var viewModel: HomeViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
    }
    
    deinit {
        bottomGradientView.removeFromSuperview()
        panelView = nil
        viewModel = nil
    }
    
    static func create(onParent parent: UIView,
                       with viewModel: HomeViewModel) -> DisplayView {
        let displayView = DisplayView.nib.instantiateSubview(onParent: parent) as! DisplayView
        displayView.viewModel = viewModel
        displayView.panelView = PanelView.create(onParent: displayView,
                                                 with: viewModel)
                                            .constraint(toParent: displayView)
        return displayView
    }
    
    private func setupViews() {
        bottomGradientView.addGradientLayer(frame: bottomGradientView.bounds,
                                            colors: [.clear, .black],
                                            locations: [0.0, 0.66])
    }
}

// MARK: - Configurable implementation

extension DisplayView: Configurable {}
