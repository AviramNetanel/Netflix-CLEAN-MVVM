//
//  DetailViewController.swift
//  netflix
//
//  Created by Zach Bazov on 07/09/2022.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var previewContainer: UIView!
    
    private var previewView: PreviewView!
    var viewModel: DetailViewModel!
    private(set) var dataSource: DetailTableViewDataSource!
    
    deinit {
        DeviceOrientation.shared.orientation = .portrait
        removeObservers()
        previewView = nil
        dataSource = nil
        viewModel = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews()
        setupObservers()
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
        previewView = PreviewView(on: previewContainer, with: viewModel)
    }
    
    private func setupDataSource() {
        let actions = DetailTableViewDataSourceActions(heightForRowAt: heightForRow())
        dataSource = DetailTableViewDataSource(on: tableView, actions: actions, with: viewModel)
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
                    return CGFloat(self.dataSource.contentSize(with: self.viewModel.navigationViewState.value))
                default:
                    return CGFloat(self.dataSource.contentSize(with: self.viewModel.navigationViewState.value))
                }
            }
        }
    }
}
