//
//  HomeTableViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - HomeTableViewDataSourceDependencies protocol

protocol HomeTableViewDataSourceDependencies {
    func createHomeTableViewDataSource() -> HomeTableViewDataSource
    func createHomeTableViewDataSourceActions() -> HomeTableViewDataSourceActions
    func createHomeDisplayTableViewCell(for indexPath: IndexPath) -> DisplayTableViewCell
    func createHomeRatedTableViewCell(for indexPath: IndexPath,
                                      with actions: HomeCollectionViewDataSourceActions) -> RatedTableViewCell
    func createHomeResumableTableViewCell(for indexPath: IndexPath,
                                          with actions: HomeCollectionViewDataSourceActions) -> ResumableTableViewCell
    func createHomeStandardTableViewCell(for indexPath: IndexPath,
                                         with actions: HomeCollectionViewDataSourceActions) -> StandardTableViewCell
    func createHomeTableViewHeaderFooterView(at section: Int) -> TableViewHeaderFooterView
}

// MARK: - HomeTableViewDataSourceActions struct

struct HomeTableViewDataSourceActions {
    
    let heightForRowAt: (IndexPath) -> CGFloat
    let viewDidScroll: (UIScrollView) -> Void
    let didSelectItem: (Int, Int) -> Void
    
//    init(coordinator: HomeCoordinator) {
//        self.heightForRowAt = coordinator.viewController!.heightForRow(at:)
//        self.viewDidScroll = coordinator.viewController!.viewDidScroll(in:)
//        self.didSelectItem = coordinator.viewController!.didSelectItem(at:of:)
//    }
    
//    init() {
//        self.heightForRowAt = { _ in return 100 }
//        self.viewDidScroll = { _ in }
//        self.didSelectItem = { _, _ in }
//    }
}

// MARK: - DataSourceInput protocol

private protocol DataSourceInput {
    func viewDidLoad()
    func viewsDidRegister()
    func dataSourceDidChange()
}

// MARK: - DataSourceOutput protocol

private protocol DataSourceOutput {
    var numberOfRows: Int { get }
    var displayCell: DisplayTableViewCell! { get }
}

// MARK: - DataSource protocol

private typealias DataSource = DataSourceInput & DataSourceOutput

// MARK: - HomeTableViewDataSource class

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
    
    private weak var tableView: UITableView!
    private let viewModel: HomeViewModel
    private var actions: HomeTableViewDataSourceActions!
    
    fileprivate let numberOfRows = 1
    fileprivate(set) var displayCell: DisplayTableViewCell!
    
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
                viewModel.actions?.presentMediaDetails(section, media)
            })
        super.init()
        self.viewDidLoad()
    }
    
    deinit {
        displayCell = nil
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
    
    fileprivate func dataSourceDidChange() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource Implementation

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

// MARK: - UIScrollViewDelegate implementation

extension HomeTableViewDataSource {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        actions.viewDidScroll(scrollView)
    }
}

// MARK: - Valuable implementation

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
