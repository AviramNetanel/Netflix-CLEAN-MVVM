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
        controller.isRotated = rotated
        
        viewController?.present(controller, animated: true)
    }
    
    func actions() -> HomeViewModelActions {
        return HomeViewModelActions(
            navigationViewDidAppear: { [weak self] in
                self?.viewController?.navigationViewTopConstraint.constant = 0.0
                self?.viewController?.navigationView.alpha = 1.0
                self?.viewController?.view.animateUsingSpring(withDuration: 0.66,
                                                              withDamping: 1.0,
                                                              initialSpringVelocity: 1.0)
                
            }, presentMediaDetails: { [weak self] section, media, rotated in
                self?.presentMediaDetails(in: section, for: media, shouldScreenRoatate: rotated)
                
            }, reloadList: { [weak self] in
                guard
                    let self = self,
                    self.viewController!.tableView.numberOfSections > 0,
                    let myListIndex = HomeTableViewDataSource.Index(rawValue: 6),
                    let section = self.viewController?.viewModel?.section(at: .myList)
                else { return }
                self.viewController?.viewModel?.filter(section: section)
                let index = IndexSet(integer: myListIndex.rawValue)
                self.viewController?.tableView.reloadSections(index, with: .automatic)
            })
    }
}
