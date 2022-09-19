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
    
    private var viewModel: DefaultDisplayViewViewModel!
    
    deinit {
        bottomGradientView = nil
        viewModel = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: DefaultHomeViewModel) -> DisplayView {
        let displayView = DisplayView.instantiateSubview(onParent: parent) as! DisplayView
        let displayViewViewModel = self.viewModel(with: viewModel)
        displayView.viewModel = displayViewViewModel
        displayView.setupSubviews()
        displayView.configure(with: displayViewViewModel)
        return displayView
    }
    
    private static func viewModel(with viewModel: DefaultHomeViewModel) -> DefaultDisplayViewViewModel {
        let media = viewModel.randomObject(at: viewModel.section(at: .display))
        let viewModel = DefaultDisplayViewViewModel(with: media)
        return viewModel
    }
    
    private func setupSubviews() {
        addGradientLayer()
        configureImageView()
    }
    
    private func addGradientLayer() {
        bottomGradientView.addGradientLayer(frame: bottomGradientView.bounds,
                                            colors: [.clear, .black],
                                            locations: [0.0, 0.66])
    }
    
    private func configureImageView() {
        posterImageView.contentMode = .scaleAspectFill
    }
    
    func configure(with viewModel: DefaultDisplayViewViewModel) {
        posterImageView.image = nil
        logoImageView.image = nil
        
        AsyncImageFetcher.shared.load(url: viewModel.posterImageURL,
                                      identifier: viewModel.posterImageIdentifier)
        { [weak self] image in DispatchQueue.main.async { self?.posterImageView.image = image } }
        
        AsyncImageFetcher.shared.load(url: viewModel.logoImageURL,
                                      identifier: viewModel.logoImageIdentifier)
        { [weak self] image in DispatchQueue.main.async { self?.logoImageView.image = image } }
        
        genresLabel.attributedText = viewModel.attributedGenres
    }
    
    func reconfigure(with viewModel: DefaultHomeViewModel) {
        let media = viewModel.randomObject(at: viewModel.section(at: .display))
        let displayViewViewModel = DefaultDisplayViewViewModel(with: media)
        configure(with: displayViewViewModel)
    }
}
