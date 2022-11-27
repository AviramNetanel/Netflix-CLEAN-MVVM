//
//  StandardTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - StandardTableViewCell class

final class StandardTableViewCell: TableViewCell<StandardCollectionViewCell> {
    
    override class func create(using homeSceneDependencies: HomeViewDIProvider,
                               for indexPath: IndexPath,
                               with actions: CollectionViewDataSourceActions? = nil) -> StandardTableViewCell {
        let identifier = StandardTableViewCell.Identifier(rawValue: indexPath.section)
        let view = homeSceneDependencies.dependencies.tableView.dequeueReusableCell(
            withIdentifier: identifier!.stringValue,
            for: indexPath) as! StandardTableViewCell
        let index = HomeTableViewDataSource.Index(rawValue: indexPath.section)!
        let section = homeSceneDependencies.dependencies.homeViewModel.section(at: index)
        view.viewDidConfigure(section: section, viewModel: homeSceneDependencies.dependencies.homeViewModel, with: actions)
        return view
    }

    enum Identifier: Int, CaseIterable, Valuable {
        case action = 3,
             sciFi,
             blockbuster,
             myList,
             crime = 7,
             thriller,
             adventure,
             comedy,
             drama,
             horror,
             anime,
             familyNchildren,
             documentary
        
        var stringValue: String {
            switch self {
            case .action: return "ActionCell"
            case .sciFi: return "SciFiCell"
            case .blockbuster: return "BlockbusterCell"
            case .myList: return "MyListCell"
            case .crime: return "CrimeCell"
            case .thriller: return "ThrillerCell"
            case .adventure: return "AdventureCell"
            case .comedy: return "ComedyCell"
            case .drama: return "DramaCell"
            case .horror: return "HorrorCell"
            case .anime: return "AnimeCell"
            case .familyNchildren: return "FamilyAndChildrenCell"
            case .documentary: return "DocumentaryCell"
            }
        }
    }
}
