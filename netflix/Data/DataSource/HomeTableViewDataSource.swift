//
//  HomeTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

struct HomeTableViewDataSourceActions {
    let heightForRowAt: (IndexPath) -> CGFloat
    let viewDidScroll: (UIScrollView) -> Void
    let didSelectItem: (Int, Int) -> Void
}

private protocol DataSourceInput {
    func viewDidLoad()
    func viewsDidRegister()
    func dataSourceDidChange()
}

private protocol DataSourceOutput {
    var numberOfRows: Int { get }
    var displayCell: DisplayTableViewCell! { get }
}

private typealias DataSource = DataSourceInput & DataSourceOutput

final class HomeTableViewDataSource: NSObject, DataSource {
    enum Index: Int, CaseIterable {
        case display
        case ratable
        case resumable
        case action
        case sciFi
        case blockbuster
        case myList
        case crime
        case thriller
        case adventure
        case comedy
        case drama
        case horror
        case anime
        case familyNchildren
        case documentary
    }
    
    enum State: Int {
        case all
        case series
        case films
    }
    
    weak var tableView: UITableView!
    private let viewModel: HomeViewModel
    var actions: HomeTableViewDataSourceActions!
    
    fileprivate let numberOfRows = 1
    var displayCell: DisplayTableViewCell!
    
    init(tableView: UITableView, viewModel: HomeViewModel) {
        self.tableView = tableView
        self.viewModel = viewModel
        self.actions = HomeTableViewDataSourceActions(
            heightForRowAt: { indexPath in
                guard let homeViewController = viewModel.coordinator?.viewController else { return .zero }
                if case .display = HomeTableViewDataSource.Index(rawValue: indexPath.section) {
                    return homeViewController.view.bounds.height * 0.76
                }
                return homeViewController.view.bounds.height * 0.19
                
            }, viewDidScroll: { scrollView in
                guard
                    let homeViewController = viewModel.coordinator?.viewController,
                    let translation = scrollView.panGestureRecognizer.translation(in: homeViewController.view) as CGPoint?
                else { return }
                homeViewController.view.animateUsingSpring(withDuration: 0.66,
                                             withDamping: 1.0,
                                             initialSpringVelocity: 1.0) {
                    guard translation.y < 0 else {
                        homeViewController.navigationViewTopConstraint.constant = 0.0
                        homeViewController.navigationView.alpha = 1.0
                        return homeViewController.view.layoutIfNeeded()
                    }
                    homeViewController.navigationViewTopConstraint.constant = -homeViewController.navigationView.bounds.size.height
                    homeViewController.navigationView.alpha = 0.0
                    homeViewController.view.layoutIfNeeded()
                }
                
            }, didSelectItem: { section, row in
                let section = viewModel.sections[section]
                let media = section.media[row]
                viewModel.actions?.presentMediaDetails(section, media, false)
            })
        super.init()
        self.viewDidLoad()
    }
    
    fileprivate func viewDidLoad() {
        viewsDidRegister()
        dataSourceDidChange()
    }
    
    fileprivate func viewsDidRegister() {
        tableView.register(headerFooter: TableViewHeaderFooterView.self)
        tableView.register(nib: DisplayTableViewCell.self)
        tableView.register(class: RatedTableViewCell.self)
        tableView.register(class: ResumableTableViewCell.self)
        tableView.register(class: StandardTableViewCell.self)
    }
    
    func dataSourceDidChange() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func terminate() {
        tableView.removeFromSuperview()
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView = nil
    }
}

extension HomeTableViewDataSource: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = Index(rawValue: indexPath.section) else { fatalError() }
        
        let actions = HomeCollectionViewDataSourceActions(
            didSelectItem: { row in
                self.actions.didSelectItem(index.rawValue, row)
            })
        
        if case .display = index {
            guard displayCell == nil else { return displayCell }
            displayCell = DisplayTableViewCell(for: indexPath, with: viewModel)
            return displayCell
        } else if case .ratable = index {
            return RatedTableViewCell(with: viewModel, for: indexPath, actions: actions)
        } else if case .resumable = index {
            return ResumableTableViewCell(with: viewModel, for: indexPath, actions: actions)
        } else {
            return StandardTableViewCell(with: viewModel, for: indexPath, actions: actions)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.coordinator!.viewController!.heightForRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return TableViewHeaderFooterView(for: section, with: viewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let index = Index(rawValue: section) else { return .zero }
        if case .display = index {
            return 0.0
        } else if case .ratable = index {
            return 28.0
        } else {
            return 24.0
        }
    }
}

extension HomeTableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        actions?.viewDidScroll(scrollView)
    }
}

extension HomeTableViewDataSource.Index: Valuable {
    var stringValue: String {
        switch self {
        case .display, .ratable, .resumable: return ""
        case .action: return "Action"
        case .sciFi: return "Sci-Fi"
        case .blockbuster: return "Blockbusters"
        case .myList: return "My List"
        case .crime: return "Crime"
        case .thriller: return "Thriller"
        case .adventure: return "Adventure"
        case .comedy: return "Comedy"
        case .drama: return "Drama"
        case .horror: return "Horror"
        case .anime: return "Anime"
        case .familyNchildren: return "Family & Children"
        case .documentary: return "Documentary"
        }
    }
}
