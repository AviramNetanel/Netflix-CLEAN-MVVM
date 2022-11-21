//
//  DisplayView.swift
//  netflix
//
//  Created by Zach Bazov on 15/09/2022.
//

import UIKit

// MARK: - ConfigurationInput protocol

private protocol ConfigurationInput {
    func viewDidConfigure(with viewModel: DisplayViewViewModel)
}

// MARK: - ConfigurationOutput protocol

private protocol ConfigurationOutput {
    var view: DisplayView! { get }
}

// MARK: - Configuration typealias

private typealias Configuration = ConfigurationInput & ConfigurationOutput

// MARK: - DisplayViewConfiguration struct

private struct DisplayViewConfiguration: Configuration {
    
    fileprivate weak var view: DisplayView!
    
    static func create(on view: DisplayView,
                       with viewModel: DisplayViewViewModel) -> DisplayViewConfiguration {
        let configuration = DisplayViewConfiguration(view: view)
        configuration.viewDidConfigure(with: viewModel)
        return configuration
    }
    
    fileprivate func viewDidConfigure(with viewModel: DisplayViewViewModel) {
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

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var panelView: PanelView! { get }
    var viewModel: DisplayViewViewModel! { get }
    var homeViewModel: HomeViewModel! { get }
    var configuration: DisplayViewConfiguration! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - DisplayView class

final class DisplayView: UIView, View, ViewInstantiable {
    
    @IBOutlet private(set) weak var posterImageView: UIImageView!
    @IBOutlet private(set) weak var logoImageView: UIImageView!
    @IBOutlet private weak var bottomGradientView: UIView!
    @IBOutlet private(set) weak var genresLabel: UILabel!
    @IBOutlet private weak var typeImageView: UIImageView!
    @IBOutlet private(set) weak var panelViewContainer: UIView!
    
    fileprivate(set) var panelView: PanelView!
    fileprivate var viewModel: DisplayViewViewModel!
    fileprivate var homeViewModel: HomeViewModel!
    fileprivate var configuration: DisplayViewConfiguration!
    
    deinit {
        panelView = nil
        viewModel = nil
        homeViewModel = nil
        configuration = nil
    }
    
    static func create(on parent: UIView,
                       with viewModel: HomeViewModel) -> DisplayView {
        let view = DisplayView(frame: .zero)
        view.nibDidLoad()
        viewModel.presentedDisplayMediaDidChange()
        createViewModel(in: view, with: viewModel)
        createConfiguration(in: view)
        createPanelView(on: view)
        view.viewDidLoad()
        return view
    }
    
    @discardableResult
    private static func createViewModel(in view: DisplayView,
                                        with homeViewModel: HomeViewModel) -> DisplayViewViewModel {
        let viewModel = DisplayViewViewModel(with: homeViewModel.presentedDisplayMedia.value!)
        view.viewModel = viewModel
        view.homeViewModel = homeViewModel
        return viewModel
    }
    
    @discardableResult
    private static func createConfiguration(in view: DisplayView) -> DisplayViewConfiguration {
        view.configuration = .create(on: view, with: view.viewModel)
        return view.configuration
    }
    
    @discardableResult
    private static func createPanelView(on view: DisplayView) -> PanelView {
        view.panelView = .create(on: view.panelViewContainer,
                                 with: view.homeViewModel)
        return view.panelView
    }
    
    fileprivate func viewDidLoad() { setupSubviews() }
    
    private func setupSubviews() { setupGradientView() }
    
    private func setupGradientView() {
        bottomGradientView.addGradientLayer(
            frame: bottomGradientView.bounds,
            colors: [.clear, .black],
            locations: [0.0, 0.66])
        
        posterImageView.contentMode = .scaleAspectFill
    }
}
