//
//  StandardTableViewCell.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - StandardTableViewCell

final class StandardTableViewCell: TableViewCell<StandardCollectionViewCell> {
    
    static func create(in tableView: UITableView,
                       for indexPath: IndexPath,
                       with viewModel: HomeViewModel) -> StandardTableViewCell {
        let identifier = StandardTableViewCell.Identifier(rawValue: indexPath.section)
        let view = tableView.dequeueReusableCell(withIdentifier: identifier!.stringValue,
                                                 for: indexPath) as! StandardTableViewCell
        view.backgroundColor = .black
        view.viewModel = viewModel
        view.configure(section: viewModel.section(at: .init(rawValue: indexPath.section)!),
                       with: viewModel)
        return view
    }

    enum Identifier: Int, CaseIterable {
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
