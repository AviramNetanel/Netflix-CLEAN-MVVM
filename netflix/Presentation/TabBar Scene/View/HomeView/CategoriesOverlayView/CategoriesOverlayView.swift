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
    func isPresentedDidChange()
    var _isPresentedDidChange: (() -> Void)? { get }
}

// MARK: - ViewOutput protocol

private protocol ViewOutput {
    var tableView: UITableView { get }
    var opaqueView: OpaqueView { get }
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
    
    private(set) lazy var opaqueView: OpaqueView = { .init(frame: UIScreen.main.bounds) }()
    private var footerView: CategoriesOverlayViewFooterView!
    private(set) var viewModel: CategoriesOverlayViewViewModel = .init()
    
    var _isPresentedDidChange: (() -> Void)?
    
    deinit {
        footerView = nil
        _isPresentedDidChange = nil
    }
    
    static func create(on parent: UIView) -> CategoriesOverlayView {
        let view = CategoriesOverlayView(frame: UIScreen.main.bounds)
        parent.addSubview(view)
        createFooter(on: parent, with: view)
        view.viewDidLoad()
        view.viewModel.viewDidLoad()
        return view
    }
    
    @discardableResult
    private static func createFooter(on parent: UIView,
                                     with view: CategoriesOverlayView) -> CategoriesOverlayViewFooterView {
        view.footerView = .create(on: parent, with: view.viewModel)
        return view.footerView
    }
    
    fileprivate func viewDidLoad() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        setupObservers()
    }
    
    private func setupObservers() {
        isPresented(in: viewModel)
    }
    
    private func setupDataSource() {
        let items: [Valuable]
        
        switch viewModel.state {
        case .tvShows,
                .movies:
            let slice = NavigationView.State.allCases[3...5]
            items = Array(slice)
            viewModel.dataSource.items = items
        case .categories:
            items = CategoriesOverlayView.Category.allCases
            viewModel.dataSource.items = items
        default:
            break
        }
        
        if tableView.delegate == nil {
            tableView.delegate = viewModel.dataSource
            tableView.dataSource = viewModel.dataSource
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
            _isPresentedDidChange?()
            setupDataSource()
            return
        }
        footerView.isHidden(true)
        isHidden(true)
        tableView.isHidden(true)
        _isPresentedDidChange?()
        
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    func removeObservers() {
        printIfDebug("Removed `DefaultCategoriesOverlayView` observers.")
        viewModel.isPresented.remove(observer: self)
    }
}

// MARK: - Observers implementation

extension CategoriesOverlayView {
    
    // MARK: CategoriesOverlayViewViewModel observers
    
    private func isPresented(in viewModel: CategoriesOverlayViewViewModel) {
        viewModel.isPresented.observe(on: self) { [weak self] _ in self?.isPresentedDidChange() }
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
