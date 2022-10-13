//
//  DetailInfoView.swift
//  netflix
//
//  Created by Zach Bazov on 30/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidConfigure(with viewModel: DetailInfoViewViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DetailInfoView class

final class DetailInfoView: UIView, View, ViewInstantiable {
    
    @IBOutlet private weak var mediaTypeLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var titlelabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var ageRestrictionViewContainer: UIView!
    @IBOutlet private weak var lengthLabel: UILabel!
    @IBOutlet private weak var hdViewContainer: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var downloadButton: UIButton!
    
    private var viewModel: DetailViewModel!
    
    static func create(on parent: UIView,
                       with viewModel: DetailViewModel) -> DetailInfoView {
        let view = DetailInfoView(frame: parent.bounds)
        view.nibDidLoad()
        view.backgroundColor = .black
        view.viewModel = viewModel
        view.setupSubviews()
        let viewModel = DetailInfoViewViewModel(with: viewModel)
        view.viewDidConfigure(with: viewModel)
        return view
    }
    
    private func setupSubviews() {
        setupHDView()
        setupAgeRestrictionView()
        setupGradientView()
    }
    
    private func setupHDView() {
        let ageRestrictionView = AgeRestrictionView.create(with: ageRestrictionViewContainer.bounds)
        ageRestrictionViewContainer.addSubview(ageRestrictionView)
    }
    
    private func setupAgeRestrictionView() {
        let hdView = HDView.create(with: hdViewContainer.bounds)
        hdViewContainer.addSubview(hdView)
    }
    
    private func setupGradientView() {
        gradientView.addGradientLayer(frame: gradientView.bounds,
                                      colors: [.init(red: 25.0/255,
                                                     green: 25.0/255,
                                                     blue: 25.0/255,
                                                     alpha: 1.0),
                                               .clear],
                                      locations: [0.3, 1.0])
    }
    
    fileprivate func viewDidConfigure(with viewModel: DetailInfoViewViewModel) {
        mediaTypeLabel.text = viewModel.mediaType
        titlelabel.text = viewModel.title
        downloadButton.setTitle(viewModel.downloadButtonTitle, for: .normal)
        lengthLabel.text = viewModel.duration
        yearLabel.text = viewModel.year
        hdViewContainer.isHidden(!viewModel.isHD)
    }
}
