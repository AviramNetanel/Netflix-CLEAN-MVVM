//
//  DisplayView.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

private protocol ConfigurationInput {
    func viewDidConfigure(with viewModel: DisplayViewViewModel)
}

private protocol ConfigurationOutput {
    var view: DisplayView! { get }
}

private typealias Configuration = ConfigurationInput & ConfigurationOutput

struct DisplayViewConfiguration: Configuration {
    fileprivate weak var view: DisplayView!
    
    init(view: DisplayView, viewModel: DisplayViewViewModel) {
        self.view = view
        self.viewDidConfigure(with: viewModel)
    }
    
    func viewDidConfigure(with viewModel: DisplayViewViewModel) {
        view.posterImageView.image = nil
        view.logoImageView.image = nil
        view.genresLabel.attributedText = nil
        
        AsyncImageFetcher.shared.load(
            url: viewModel.posterImageURL,
            identifier: viewModel.posterImageIdentifier) { image in
                DispatchQueue.main.async { view.posterImageView.image = image }
            }
        
        AsyncImageFetcher.shared.load(
            url: viewModel.logoImageURL,
            identifier: viewModel.logoImageIdentifier) { image in
                DispatchQueue.main.async { view.logoImageView.image = image }
            }
        
        view.genresLabel.attributedText = viewModel.attributedGenres
    }
}

final class DisplayView: UIView, ViewInstantiable {
    @IBOutlet private(set) weak var posterImageView: UIImageView!
    @IBOutlet private(set) weak var logoImageView: UIImageView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private(set) weak var genresLabel: UILabel!
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private(set) weak var panelViewContainer: UIView!
    
    private var viewModel: DisplayViewViewModel!
    fileprivate(set) var configuration: DisplayViewConfiguration!
    fileprivate(set) var panelView: PanelView!
    
    init(with viewModel: DisplayTableViewCellViewModel) {
        super.init(frame: .zero)
        self.nibDidLoad()
        viewModel.presentedDisplayMediaDidChange()
        self.viewModel = DisplayViewViewModel(with: viewModel.presentedDisplayMedia.value!)
        self.configuration = DisplayViewConfiguration(view: self, viewModel: self.viewModel)
        self.panelView = PanelView(on: panelViewContainer, with: viewModel)
        self.viewDidLoad()
    }
    
    deinit {
        panelView = nil
        configuration = nil
        viewModel = nil
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    fileprivate func viewDidLoad() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        setupGradientView()
    }
    
    private func setupGradientView() {
        bottomGradientView.addGradientLayer(
            frame: bottomGradientView.bounds,
            colors: [.clear, .black],
            locations: [0.0, 0.66])
        
        posterImageView.contentMode = .scaleAspectFill
    }
}
