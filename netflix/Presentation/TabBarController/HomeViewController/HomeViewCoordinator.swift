//
//  HomeViewCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

final class HomeViewCoordinator: Coordinate {
    enum Screen {
        case detail
    }
    
    var viewController: HomeViewController?
    
    func showScreen(_ screen: Screen) {}
    
    func presentMediaDetails(in section: Section, for media: Media, shouldScreenRoatate rotated: Bool) {
        let controller = DetailViewController()
        let homeViewModel = viewController!.viewModel!
        let viewModel = DetailViewModel(section: section, media: media, with: homeViewModel)
        controller.viewModel = viewModel
        controller.viewModel.coordinator = DetailViewCoordinator()
        controller.viewModel.coordinator?.viewController = controller
        controller.viewModel.isRotated = rotated
        
        let navigation = UINavigationController(rootViewController: controller)
        navigation.setNavigationBarHidden(true, animated: false)
        
        viewController?.present(navigation, animated: true)
    }
    
    func actions() -> HomeViewModelActions {
        return HomeViewModelActions(
            presentMediaDetails: { [weak self] section, media, rotated in
                self?.presentMediaDetails(in: section, for: media, shouldScreenRoatate: rotated)
            })
    }
}
