//
//  CategoriesOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewDependencies protocol

protocol CategoriesOverlayViewDependencies {
    func createCategoriesOverlayViewTableViewCell(using provider: CategoriesOverlayViewDIProvider,
                                                  for indexPath: IndexPath) -> CategoriesOverlayViewTableViewCell
}

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
    func itemsDidChange()
    func dataSourceDidChange()
    func isPresentedDidChange()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var opaqueView: OpaqueView { get }
    var footerView: CategoriesOverlayViewFooterView! { get }
    var viewModel: CategoriesOverlayViewViewModel { get }
    var dataSource: CategoriesOverlayViewTableViewDataSource! { get }
}

// MARK: - View typealias

private typealias View = ViewInput & ViewOutput

// MARK: - CategoriesOverlayView class

final class CategoriesOverlayView: UIView, View {
    
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
    
    private(set) var categoriesOverlayViewDependencies: CategoriesOverlayViewDIProvider!
    fileprivate var dataSource: CategoriesOverlayViewTableViewDataSource!
    fileprivate var footerView: CategoriesOverlayViewFooterView!
    let opaqueView: OpaqueView = OpaqueView(frame: UIScreen.main.bounds)
    let viewModel = CategoriesOverlayViewViewModel()
    
    deinit {
        footerView = nil
        dataSource = nil
    }
    
    static func create(using homeSceneDependencies: HomeViewDIProvider, on parent: UIView) -> CategoriesOverlayView {
        let view = CategoriesOverlayView(frame: UIScreen.main.bounds)
        parent.addSubview(view)
        view.setupDependencies(using: homeSceneDependencies)
        createDataSource(on: view, with: view.viewModel)
        createFooter(on: parent, with: view)
        view.viewDidLoad()
        return view
    }
    
    @discardableResult
    private static func createDataSource(on view: CategoriesOverlayView,
                                         with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewTableViewDataSource {
        view.dataSource = CategoriesOverlayViewTableViewDataSource(with: viewModel)
        return view.dataSource
    }
    
    @discardableResult
    private static func createFooter(on parent: UIView,
                                     with view: CategoriesOverlayView) -> CategoriesOverlayViewFooterView {
        view.footerView = .create(on: parent, with: view.viewModel)
        return view.footerView
    }
    
    private func setupDependencies(using tabBarSceneDIProvider: HomeViewDIProvider) {
        categoriesOverlayViewDependencies = tabBarSceneDIProvider.createCategoriesOverlayViewDIProvider(using: createTableView(), viewModel: viewModel)
    }
    
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
        guard let tableView = categoriesOverlayViewDependencies.dependencies.tableView else { return }
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
        guard let tableView = categoriesOverlayViewDependencies.dependencies.tableView else { return }
        if case true = viewModel.isPresented.value {
            isHidden(false)
            tableView.isHidden(false)
            footerView.isHidden(false)
            viewModel.isPresentedDidChange?()
            itemsDidChange()
            return
        }
        
        isHidden(true)
        footerView.isHidden(true)
        tableView.isHidden(true)
        viewModel.isPresentedDidChange?()
        
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    func removeObservers() {
        printIfDebug("Removed `CategoriesOverlayView` observers.")
        viewModel.isPresented.remove(observer: self)
        viewModel.items.remove(observer: self)
    }
}

// MARK: - Observers implementation

extension CategoriesOverlayView {
    
    private func isPresented(in viewModel: CategoriesOverlayViewViewModel) {
        viewModel.isPresented.observe(on: self) { [weak self] _ in self?.isPresentedDidChange() }
    }
    
    private func items(in viewModel: CategoriesOverlayViewViewModel) {
        viewModel.items.observe(on: self) { [weak self] _ in self?.dataSourceDidChange() }
    }
}

// MARK: - Valuable implementation

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
