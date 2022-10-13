//
//  DisplayView.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
    func viewDidConfigure(with viewModel: DisplayViewViewModel)
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DisplayView class

final class DisplayView: UIView, ViewInstantiable {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private weak var genresLabel: UILabel!
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private(set) weak var panelView: PanelView!
    
    var viewModel: DisplayViewViewModel! { didSet { viewDidConfigure(with: viewModel) } }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.nibDidLoad()
        self.viewDidLoad()
    }
    
    deinit { viewModel = nil }
    
    fileprivate func viewDidLoad() {
        bottomGradientView.addGradientLayer(
            frame: bottomGradientView.bounds,
            colors: [.clear, .black],
            locations: [0.0, 0.66])
        
        posterImageView.contentMode = .scaleAspectFill
    }
    
    fileprivate func viewDidConfigure(with viewModel: DisplayViewViewModel) {
        posterImageView.image = nil
        logoImageView.image = nil
        genresLabel.attributedText = nil
        
        AsyncImageFetcher.shared.load(
            url: viewModel.posterImageURL,
            identifier: viewModel.posterImageIdentifier) { [weak self] image in
                DispatchQueue.main.async { self?.posterImageView.image = image }
            }
        
        AsyncImageFetcher.shared.load(
            url: viewModel.logoImageURL,
            identifier: viewModel.logoImageIdentifier) { [weak self] image in
                DispatchQueue.main.async { self?.logoImageView.image = image }
            }
        
        genresLabel.attributedText = viewModel.attributedGenres
    }
}
