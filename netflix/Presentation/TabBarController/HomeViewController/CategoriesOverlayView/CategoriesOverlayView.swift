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
        case drama
        case horror
        case anime
        case familyNchildren
        case documentary
    }
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.register(class: CategoriesOverlayViewTableViewCell.self)
        return tableView
    }()
    let tabBar: UITabBar
    let viewModel: CategoriesOverlayViewViewModel
    private(set) var dataSource: CategoriesOverlayViewTableViewDataSource!
    let opaqueView = OpaqueView(frame: UIScreen.main.bounds)
    let footerView: CategoriesOverlayViewFooterView
    
    init(with viewModel: HomeViewModel) {
        self.tabBar = viewModel.coordinator!.viewController!.tabBarController!.tabBar
        self.viewModel = CategoriesOverlayViewViewModel(with: viewModel)
        
        let parent = viewModel.coordinator!.viewController!.view!
        self.footerView = CategoriesOverlayViewFooterView(parent: parent, viewModel: self.viewModel)
        
        super.init(frame: UIScreen.main.bounds)
        parent.addSubview(self)
        parent.addSubview(self.footerView)
        self.addSubview(self.tableView)
        
        self.dataSource = CategoriesOverlayViewTableViewDataSource(on: self.tableView, with: self.viewModel)
        
        /// Updates root coordinator's `categoriesOverlayView` property.
        viewModel.coordinator?.viewController?.categoriesOverlayView = self
        
        self.viewDidLoad()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func viewDidLoad() {
        setupObservers()
        setupSubviews()
    }
    
    private func setupObservers() {
        isPresented(in: viewModel)
        items(in: viewModel)
    }
    
    private func setupSubviews() {
        tableView.backgroundView = opaqueView
    }
    
    func removeObservers() {
        printIfDebug("Removed `CategoriesOverlayView` observers.")
        viewModel.isPresented.remove(observer: self)
        viewModel.items.remove(observer: self)
    }
}

extension CategoriesOverlayView {
    private func isPresented(in viewModel: CategoriesOverlayViewViewModel) {
        viewModel.isPresented.observe(on: self) { [weak self] _ in self?.viewModel.isPresentedDidChange() }
    }
    
    private func items(in viewModel: CategoriesOverlayViewViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.viewModel.dataSourceDidChange() }
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
        case .drama: return "Drama"
        case .horror: return "Horror"
        case .anime: return "Anime"
        case .familyNchildren: return "Family & Children"
        case .documentary: return "Documentary"
        }
    }
}

extension CategoriesOverlayView.Category {
    func toSection(with viewModel: HomeViewModel) -> Section {
        switch self {
        case .home: return viewModel.section(at: .resumable)
        case .myList: return viewModel.section(at: .myList)
        case .action: return viewModel.section(at: .action)
        case .sciFi: return viewModel.section(at: .sciFi)
        case .crime: return viewModel.section(at: .crime)
        case .thriller: return viewModel.section(at: .thriller)
        case .adventure: return viewModel.section(at: .adventure)
        case .comedy: return viewModel.section(at: .comedy)
        case .drama: return viewModel.section(at: .drama)
        case .horror: return viewModel.section(at: .horror)
        case .anime: return viewModel.section(at: .anime)
        case .familyNchildren: return viewModel.section(at: .familyNchildren)
        case .documentary: return viewModel.section(at: .documentary)
        }
    }
}
