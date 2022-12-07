//
//  CategoriesOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

final class CategoriesOverlayView: UIView {
    enum Category: Int, CaseIterable {
        case home
        case myList
        case action
        case sciFi
        case crime
        case thriller
        case adventure
        case comedy
        case horror
        case anime
        case familyNchildren
        case documentary
    }
    
    private var tabBar: UITabBar?
    fileprivate(set) lazy var tableView: UITableView = createTableView()
    var viewModel: CategoriesOverlayViewViewModel!
    var dataSource: CategoriesOverlayViewTableViewDataSource!
    let opaqueView: OpaqueView
    fileprivate var footerView: CategoriesOverlayViewFooterView
    
    init(with viewModel: HomeViewModel) {
        self.tabBar = viewModel.coordinator?.viewController?.tabBarController?.tabBar
        self.viewModel = CategoriesOverlayViewViewModel()
        self.opaqueView = OpaqueView(frame: UIScreen.main.bounds)
        let parent = viewModel.coordinator?.viewController?.view
        self.footerView = CategoriesOverlayViewFooterView(parent: parent ?? .init(), viewModel: self.viewModel)
        super.init(frame: UIScreen.main.bounds)
        self.dataSource = CategoriesOverlayViewTableViewDataSource(on: tableView, with: self.viewModel)
        parent?.addSubview(self)
        parent?.addSubview(footerView)
        self.viewDidLoad()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func createTableView() -> UITableView {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundView = opaqueView
        tableView.register(class: CategoriesOverlayViewTableViewCell.self)
        addSubview(tableView)
        return tableView
    }
    
    fileprivate func viewDidLoad() {
        setupObservers()
    }
    
    fileprivate func setupObservers() {
        isPresented(in: viewModel)
        items(in: viewModel)
    }
    
    fileprivate func itemsDidChange() {
        switch viewModel.state {
        case .none:
            viewModel.items.value = []
        case .mainMenu:
            let states = NavigationView.State.allCases[3...5].toArray()
            viewModel.items.value = states
        case .categories:
            let categories = CategoriesOverlayView.Category.allCases
            viewModel.items.value = categories
        }
    }
    
    fileprivate func dataSourceDidChange() {
        if tableView.delegate == nil {
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
        }
        
        tableView.reloadData()
        
        tableView.contentInset = .init(
            top: (UIScreen.main.bounds.height - tableView.contentSize.height) / 2 - 80.0,
            left: .zero,
            bottom: (UIScreen.main.bounds.height - tableView.contentSize.height) / 2,
            right: .zero)
    }
    
    fileprivate func isPresentedDidChange() {
        if case true = viewModel.isPresented.value {
            isHidden(false)
            tableView.isHidden(false)
            footerView.isHidden(false)
            tabBar?.isHidden(true)
            
            itemsDidChange()
            return
        }
        
        isHidden(true)
        footerView.isHidden(true)
        tableView.isHidden(true)
        tabBar?.isHidden(false)
        
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    func removeObservers() {
        printIfDebug("Removed `CategoriesOverlayView` observers.")
        viewModel.isPresented.remove(observer: self)
        viewModel.items.remove(observer: self)
    }
}

extension CategoriesOverlayView {
    private func isPresented(in viewModel: CategoriesOverlayViewViewModel) {
        viewModel.isPresented.observe(on: self) { [weak self] _ in self?.isPresentedDidChange() }
    }
    
    private func items(in viewModel: CategoriesOverlayViewViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.dataSourceDidChange() }
    }
}

extension CategoriesOverlayView.Category: Valuable {
    var stringValue: String {
        switch self {
        case .home: return "Home"
        case .myList: return "My List"
        case .action: return "Action"
        case .sciFi: return "Sci-Fi"
        case .crime: return "Crime"
        case .thriller: return "Thriller"
        case .adventure: return "Adventure"
        case .comedy: return "Comedy"
        case .horror: return "Horror"
        case .anime: return "Anime"
        case .familyNchildren: return "Family & Children"
        case .documentary: return "Documentary"
        }
    }
}
