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
        DeviceOrientation.shared.orientation = .portrait
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
        setupView()
        setupSubviews()
        setupObservers()
        viewModel.viewDidLoad()
    }
    
    private func setupDependencies() {
        diProvider = tabBarSceneDIProvider.createDetailViewDIProvider(launchingViewController: self)
    }
    
    private func setupView() {
        DeviceOrientation.shared.orientation = .all
    }
    
    private func setupSubviews() {
        setupPreviewView()
        setupDataSource()
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
            viewModel.navigationViewState.remove(observer: self)
            viewModel.season.remove(observer: self)
        }
        if let panelView = dataSource.panelCell.panelView {
            printIfDebug("Removed `DetailPanelViewItem` observers.")
            panelView.leadingItem.viewModel.removeObservers()
            panelView.centerItem.viewModel.removeObservers()
            panelView.trailingItem.viewModel.removeObservers()
        }
    }
}

// MARK: - Observer bindings

extension DetailViewController {
    
    private func navigationViewState(in viewModel: DetailViewModel) {
        viewModel.navigationViewState.observe(on: self) { [weak self] state in
            self?.dataSource?.collectionCell?.detailCollectionView?.dataSourceDidChange()
            self?.tableView.reloadData()
        }
    }
    
    private func season(in viewModel: DetailViewModel) {
        viewModel.season.observe(on: self) { [weak self] season in
            self?.dataSource?.collectionCell?.detailCollectionView?.dataSourceDidChange()
            self?.tableView.reloadData()
        }
    }
}

// MARK: - DetailTableViewDataSourceActions implementation

extension DetailViewController {
    
    func heightForRow() -> (IndexPath) -> CGFloat {
        return { [weak self] indexPath in
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
