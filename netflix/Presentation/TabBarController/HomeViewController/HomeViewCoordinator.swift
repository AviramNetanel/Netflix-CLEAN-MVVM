//
//  HomeViewCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

// MARK: - HomeViewCoordinator class

final class HomeViewCoordinator: Coordinate {
    
    enum Screen {
        case detail
    }
    
    var viewController: HomeViewController?
    
    func showScreen(_ screen: Screen) {}
    
    func presentDetailViewController(section: Section, media: Media) -> UIViewController {
        let dataTransferService = Application.current.coordinator.dataTransferService
        let repository = SeasonRepository(dataTransferService: dataTransferService)
        let useCase = DetailUseCase(seasonsRepository: repository)
        let controller = DetailViewController()
        let homeViewModel = viewController!.viewModel!
        let viewModel = DetailViewModel(useCase: useCase, section: section, media: media, with: homeViewModel)
        controller.viewModel = viewModel
        viewController?.present(controller, animated: true)
        return controller
    }
}
