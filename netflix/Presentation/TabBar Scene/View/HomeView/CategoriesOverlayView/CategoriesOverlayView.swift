//
//  CategoriesOverlayView.swift
//  netflix
//
//  Created by Zach Bazov on 20/09/2022.
//

import UIKit

// MARK: - ViewInput protocol

private protocol ViewInput {
    func viewDidLoad()
    func viewDidObserve()
    func viewDidUnobserve()
    func dataSourceDidChange()
    func itemsDidChange()
    func isPresentedDidChange()
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var tableView: UITableView { get }
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
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView(frame: UIScreen.main.bounds, style: .plain)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.backgroundView = opaqueView
        tableView.register(class: CategoriesOverlayViewTableViewCell.self)
        addSubview(tableView)
        return tableView
    }()
    
    fileprivate var dataSource: CategoriesOverlayViewTableViewDataSource!
    fileprivate(set) lazy var opaqueView: OpaqueView = { .init(frame: UIScreen.main.bounds) }()
    fileprivate var footerView: CategoriesOverlayViewFooterView!
    private(set) var viewModel: CategoriesOverlayViewViewModel = .init()
    
    deinit {
        footerView = nil
        dataSource = nil
    }
    
    static func create(on parent: UIView) -> CategoriesOverlayView {
        let view = CategoriesOverlayView(frame: UIScreen.main.bounds)
        parent.addSubview(view)
        createDataSource(on: view, with: view.viewModel)
        createFooter(on: parent, with: view)
        view.viewDidLoad()
        return view
    }
    
    @discardableResult
    private static func createDataSource(on view: CategoriesOverlayView,
                                         with viewModel: CategoriesOverlayViewViewModel) -> CategoriesOverlayViewTableViewDataSource {
        view.dataSource = .create(with: viewModel)
        return view.dataSource
    }
    
    @discardableResult
    private static func createFooter(on parent: UIView,
                                     with view: CategoriesOverlayView) -> CategoriesOverlayViewFooterView {
        view.footerView = .create(on: parent, with: view.viewModel)
        return view.footerView
    }
    
    fileprivate func viewDidLoad() { viewDidObserve() }
    
    fileprivate func viewDidObserve() {
        isPresented(in: viewModel)
        items(in: dataSource)
    }
    
    fileprivate func dataSourceDidChange() {
        switch viewModel.state {
        case .none:
            dataSource.items.value = []
        case .mainMenu:
            let items = NavigationView.State.allCases[3...5].toArray()
            dataSource.items.value = items
        case .categories:
            let items = CategoriesOverlayView.Category.allCases
            dataSource.items.value = items
        }
    }
    
    func viewDidUnobserve() {
        printIfDebug("Removed `CategoriesOverlayView` observers.")
        viewModel.isPresented.remove(observer: self)
        dataSource.items.remove(observer: self)
    }
}

// MARK: - Observers implementation

extension CategoriesOverlayView {
    
    // MARK: CategoriesOverlayViewViewModel observers
    
    fileprivate func isPresented(in viewModel: CategoriesOverlayViewViewModel) {
        viewModel.isPresented.observe(on: self) { [weak self] _ in self?.isPresentedDidChange() }
    }
    
    // MARK: CategoriesOverlayViewTableViewDataSource observers
    
    fileprivate func items(in dataSource: CategoriesOverlayViewTableViewDataSource) {
        dataSource.items.observe(on: self) { [weak self] _ in self?.itemsDidChange() }
    }
}

// MARK: - Observers methods

extension CategoriesOverlayView {
    
    fileprivate func itemsDidChange() {
        if tableView.delegate == nil {
            tableView.delegate = dataSource
            tableView.dataSource = dataSource
        }
        
        tableView.reloadData()
        
        tableView.contentInset = .init(
            top: (UIScreen.main.bounds.height - tableView.contentSize.height) / 2 - 60.0,
            left: .zero,
            bottom: (UIScreen.main.bounds.height - tableView.contentSize.height) / 2,
            right: .zero)
    }
    
    fileprivate func isPresentedDidChange() {
        if case true = viewModel.isPresented.value {
            isHidden(false)
            tableView.isHidden(false)
            footerView.isHidden(false)
            viewModel._isPresentedDidChange?()
            dataSourceDidChange()
            return
        }
        isHidden(true)
        footerView.isHidden(true)
        tableView.isHidden(true)
        viewModel._isPresentedDidChange?()
        
        tableView.delegate = nil
        tableView.dataSource = nil
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
