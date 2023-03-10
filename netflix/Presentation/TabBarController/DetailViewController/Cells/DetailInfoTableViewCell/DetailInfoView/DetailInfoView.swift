//
//  DetailInfoView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

final class DetailInfoView: UIView, ViewInstantiable {
    @IBOutlet private weak var mediaTypeLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var titlelabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var ageRestrictionViewContainer: UIView!
    @IBOutlet private weak var lengthLabel: UILabel!
    @IBOutlet private weak var hdViewContainer: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var downloadButton: UIButton!
    
    private let viewModel: DetailInfoViewViewModel
    var ageRestrictionView: AgeRestrictionView!
    var hdView: HDView!
    
    init(on parent: UIView, with viewModel: DetailInfoViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: parent.bounds)
        self.nibDidLoad()
        self.ageRestrictionView = AgeRestrictionView(on: ageRestrictionViewContainer)
        self.hdView = HDView(on: hdViewContainer)
        self.viewDidLoad()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func viewDidLoad() {
        setupSubviews()
        viewDidConfigure()
    }
    
    private func viewDidConfigure() {
        backgroundColor = .black
        
        mediaTypeLabel.text = viewModel.mediaType
        titlelabel.text = viewModel.title
        downloadButton.setTitle(viewModel.downloadButtonTitle, for: .normal)
        lengthLabel.text = viewModel.length
        yearLabel.text = viewModel.duration
        hdViewContainer.isHidden(!viewModel.isHD)
    }
    
    private func setupSubviews() {
        setupGradientView()
    }
    
    private func setupGradientView() {
        gradientView.addGradientLayer(
            frame: gradientView.bounds,
            colors: [UIColor(red: 25.0/255,
                             green: 25.0/255,
                             blue: 25.0/255,
                             alpha: 1.0),
                     .clear],
            locations: [0.3, 1.0])
    }
}
