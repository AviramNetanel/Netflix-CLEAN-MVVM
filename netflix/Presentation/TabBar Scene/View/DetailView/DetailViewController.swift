//
//  DetailViewController.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import UIKit

// MARK: - DetailViewController class

final class DetailViewController: UIViewController {
    
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var previewContainer: UIView!
    
    private var diProvider: DetailViewDIProvider!
    private var previewView: PreviewView!
    private(set) var viewModel: DetailViewModel!
    private(set) var dataSource: DetailTableViewDataSource!
    
    deinit {
        removeObservers()
        previewView = nil
        dataSource = nil
        viewModel = nil
        diProvider = nil
    }
    
    static func create(with viewModel: DetailViewModel) -> DetailViewController {
        let view = Storyboard(withOwner: TabBarController.self,
                              launchingViewController: DetailViewController.self)
            .instantiate() as! DetailViewController
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDependencies()
        setupSubviews()
        setupBindings()
        setupObservers()
        viewModel.viewDidLoad()
    }
    
    private func setupDependencies() {
        diProvider = tabBarSceneDIProvider.createDetailViewDIProvider(launchingViewController: self)
    }
    
    private func setupSubviews() {
        setupPreviewView()
        setupDataSource()
    }
    
    private func setupBindings() {
        heightForRow(in: dataSource)
    }
    
    private func setupObservers() {
        navigationViewState(in: viewModel)
        season(in: viewModel)
    }
    
    private func setupPreviewView() {
        previewView = diProvider.createPreviewView()
    }
    
    private func setupDataSource() {
        dataSource = diProvider.createDetailTableViewDataSource()
    }
    
    func removeObservers() {
        if let viewModel = viewModel {
            printIfDebug("Removed `DetailViewModel` observers.")
            viewModel.season.remove(observer: self)
        }
        if let panelView = dataSource.panelCell.panelView {
            printIfDebug("Removed `DetailPanelViewItem` observers.")
            panelView.leadingItem.viewModel.removeObservers()
            panelView.centerItem.viewModel.removeObservers()
            panelView.trailingItem.viewModel.removeObservers()
        }
//        if let navigationView = dataSource.navigationCell.navigationView {
//            printIfDebug("Removed `DetailNavigationView` observers.")
//            navigationView.removeObservers()
//        }
    }
}

// MARK: - Bindings

extension DetailViewController {
    
    // MARK: DetailTableViewDataSource bindings
    
    private func heightForRow(in dataSource: DetailTableViewDataSource) {
        dataSource._heightForRow = { [weak self] indexPath in
            guard
                let self = self,
                let index = DetailTableViewDataSource.Index(rawValue: indexPath.section)
            else { return .zero }
            switch index {
            case .info: return self.view.bounds.height * 0.21
            case .description: return self.view.bounds.height * 0.135
            case .panel: return self.view.bounds.height * 0.0764
            case .navigation: return self.view.bounds.height * 0.0764
            case .collection:
                switch self.viewModel.navigationViewState.value {
                case .episodes, .trailers:
                    return CGFloat(self.viewModel.contentSize(with: self.viewModel.navigationViewState.value))
                default:
                    return CGFloat(self.viewModel.contentSize(with: self.viewModel.navigationViewState.value))
                }
            }
        }
    }
}

// MARK: - Observers

extension DetailViewController {
    
    // MARK: DetailViewModel observers
    
    private func navigationViewState(in viewModel: DetailViewModel) {
        viewModel.navigationViewState.observe(on: self) { [weak self] state in
            self?.dataSource?.collectionCell?.detailCollectionView?.dataSourceDidChange()
            self?.heightForRow(in: self!.dataSource)
        }
    }
    
    private func season(in viewModel: DetailViewModel) {
        viewModel.season.observe(on: self) { [weak self] season in
            self?.dataSource?.collectionCell?.detailCollectionView?.dataSourceDidChange()
            self?.heightForRow(in: self!.dataSource)
        }
    }
}
