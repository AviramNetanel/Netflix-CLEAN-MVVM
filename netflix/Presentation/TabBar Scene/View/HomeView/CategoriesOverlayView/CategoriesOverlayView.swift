//
//  CategoriesOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewDependencies protocol

protocol CategoriesOverlayViewDependencies {
    func createCategoriesOverlayView() -> CategoriesOverlayView
    func createCategoriesOverlayViewViewModel() -> CategoriesOverlayViewViewModel
    func createCategoriesOverlayViewTableViewDataSource(with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewTableViewDataSource
    func createCategoriesOverlayViewTableViewCell(for indexPath: IndexPath) -> CategoriesOverlayViewTableViewCell
    func createCategoriesOverlayViewFooterView(on parent: UIView,
                                               with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewFooterView
    func createCategoriesOverlayViewOpaqueView() -> OpaqueView
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
    var tableView: UITableView { get }
    var viewModel: CategoriesOverlayViewViewModel { get }
    var dataSource: CategoriesOverlayViewTableViewDataSource { get }
    var opaqueView: OpaqueView { get }
    var footerView: CategoriesOverlayViewFooterView { get }
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
    
    fileprivate(set) lazy var tableView: UITableView = createTableView()
    let viewModel: CategoriesOverlayViewViewModel
    let dataSource: CategoriesOverlayViewTableViewDataSource
    let opaqueView: OpaqueView
    fileprivate var footerView: CategoriesOverlayViewFooterView
    
    init(using diProvider: HomeViewDIProvider) {
        self.viewModel = diProvider.createCategoriesOverlayViewViewModel()
        self.dataSource = diProvider.createCategoriesOverlayViewTableViewDataSource(with: viewModel)
        self.opaqueView = diProvider.createCategoriesOverlayViewOpaqueView()
        let parent = diProvider.dependencies.homeViewController.view!
        self.footerView = diProvider.createCategoriesOverlayViewFooterView(on: parent, with: viewModel)
        super.init(frame: UIScreen.main.bounds)
        parent.addSubview(self)
        parent.addSubview(footerView)
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

// MARK: - Observer bindings

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
