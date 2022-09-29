//
//  DefaultCategoriesOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

// MARK: - CategoriesOverlayViewInput protocol

private protocol CategoriesOverlayViewInput {
    func isPresentedDidChange()
}

// MARK: - CategoriesOverlayViewOutput protocol

private protocol CategoriesOverlayViewOutput {
    var tableView: UITableView { get }
    var opaqueView: DefaultOpaqueView! { get }
}

// MARK: - CategoriesOverlayView protocol

private protocol CategoriesOverlayView: CategoriesOverlayViewInput,
                                        CategoriesOverlayViewOutput {}

// MARK: - DefaultCategoriesOverlayView class

final class DefaultCategoriesOverlayView: UIView, CategoriesOverlayView {
    
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
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundView = opaqueView
        tableView.register(CategoriesOverlayViewTableViewCell.self,
                           forCellReuseIdentifier: CategoriesOverlayViewTableViewCell.reuseIdentifier)
        addSubview(tableView)
        return tableView
    }()
    
    private(set) lazy var opaqueView: DefaultOpaqueView! = { .init(frame: UIScreen.main.bounds) }()
    
    private(set) var viewModel = DefaultCategoriesOverlayViewViewModel()
    
    private var footer: CategoriesOverlayViewFooterView!
    
    deinit { footer = nil }
    
    static func create(on parent: UIView) -> DefaultCategoriesOverlayView {
        let view = DefaultCategoriesOverlayView(frame: UIScreen.main.bounds)
        parent.addSubview(view)
        view.setupSubviews(parent: parent)
        view.setupBindings()
        view.viewModel.viewDidLoad()
        return view
    }
    
    private func setupSubviews(parent: UIView) {
        setupFooterView(on: parent)
    }
    
    private func setupBindings() {
        isPresented(in: viewModel)
    }
    
    private func setupFooterView(on parent: UIView) {
        footer = CategoriesOverlayViewFooterView.create(on: parent,
                                                        frame: .zero,
                                                        with: viewModel)
    }
    
    private func isPresented(in viewModel: DefaultCategoriesOverlayViewViewModel) {
        viewModel.isPresented.observe(on: self) { [weak self] _ in self?.isPresentedDidChange() }
    }
    
    private func setupDataSource() {
        let items: [Valuable]
        
        switch viewModel.state {
        case .tvShows,
                .movies:
            let slice = DefaultNavigationView.State.allCases[3...5]
            items = Array(slice)
            viewModel.dataSource.items = items
        case .categories:
            items = DefaultCategoriesOverlayView.Category.allCases
            viewModel.dataSource.items = items
        default:
            break
        }
        
        if tableView.delegate == nil {
            tableView.delegate = viewModel.dataSource
            tableView.dataSource = viewModel.dataSource
        }
        
        tableView.reloadData()
        
        tableView.contentInset = .init(top: (UIScreen.main.bounds.height - tableView.contentSize.height) / 2 - 60.0,
                                       left: .zero,
                                       bottom: (UIScreen.main.bounds.height - tableView.contentSize.height) / 2,
                                       right: .zero)
    }
    
    fileprivate func isPresentedDidChange() {
        if case true = viewModel.isPresented.value {
            isHidden(false)
            tableView.isHidden(false)
            footer.isHidden(false)
            viewModel.dataSource.tabBarController?.tabBar.isHidden(true)
            setupDataSource()
            return
        }
        footer.isHidden(true)
        isHidden(true)
        tableView.isHidden(true)
        viewModel.dataSource?.tabBarController?.tabBar.isHidden(false)
        
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    func removeObservers() {
        printIfDebug("Removed `DefaultCategoriesOverlayView` observers.")
        viewModel.isPresented.remove(observer: self)
    }
}

// MARK: - Valuable implementation

extension DefaultCategoriesOverlayView.Category: Valuable {
    
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
