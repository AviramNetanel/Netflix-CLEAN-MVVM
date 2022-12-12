//
//  DetailViewCoordinator.swift
//  netflix
//
//  Created by Zach Bazov on 05/12/2022.
//

import UIKit

final class DetailViewCoordinator: Coordinate {
    enum Screen {
        case detail
    }
    
    weak var viewController: DetailViewController?
    
    func showScreen(_ screen: Screen) {}
    
    func presentDetails(for media: Media) {
        let navigation = viewController?.navigationController
        let controller = DetailViewController()
        let viewModel = viewController?.viewModel
        
        viewController?.previewView?.mediaPlayerView?.stopPlayer()
        viewController = nil
        
        controller.viewModel = viewModel
        controller.viewModel.media = media
        viewController = controller
        
        navigation?.setViewControllers([controller], animated: true)
    }
}
