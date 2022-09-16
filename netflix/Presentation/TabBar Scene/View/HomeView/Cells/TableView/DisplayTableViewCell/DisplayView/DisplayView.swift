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
    
    static func viewModel(with viewModel: DefaultHomeViewModel) -> DefaultDisplayViewViewModel {
        let media = viewModel.randomObject(at: viewModel.section(at: .display))!
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
    
    private func configure(with viewModel: DefaultDisplayViewViewModel) {
        let posterIdentifier = "displayPoster_\(viewModel.slug)" as NSString
        let logoIdentifier = "displayLogo_\(viewModel.slug)" as NSString
        let posterURL = URL(string: viewModel.posterImagePath)!
        let logoURL = URL(string: viewModel.logoImagePath)!
        AsyncImageFetcher.shared.load(url: posterURL, identifier: posterIdentifier) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.posterImageView.image = image }
        }
        AsyncImageFetcher.shared.load(url: logoURL, identifier: logoIdentifier) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.logoImageView.image = image }
        }
        // genres
        // path func to displayviewviewmodel
    }
}

//

private protocol DisplayViewViewModel {
    var slug: String { get }
    var posterImagePath: String { get }
    var logoImagePath: String { get }
    var genres: [String] { get }
}

struct DefaultDisplayViewViewModel: DisplayViewViewModel {
    
    let slug: String
    let posterImagePath: String
    let logoImagePath: String
    let genres: [String]
    
    init(with media: Media) {
        self.slug = media.slug
        self.posterImagePath = media.displayCover
        self.logoImagePath = media.displayLogos!.first!
        self.genres = media.genres
    }
}
