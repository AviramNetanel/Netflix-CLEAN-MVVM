//
//  CollectionViewSnapshot.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CollectionViewDelegate

protocol CollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: CollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: CollectionViewCell, forItemAt indexPath: IndexPath)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, with viewModel: DefaultHomeViewModel)
}


// MARK: - CollectionViewDataSource

protocol CollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> CollectionViewCell
    func collectionView(_ collectionView: UICollectionView, willConfigure cell: CollectionViewCell, forItemAt indexPath: IndexPath) -> CollectionViewCell?
}


// MARK: - CollectionViewDataSourcePrefetching

protocol CollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath])
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath])
}


// MARK: - CollectionViewSnapshotDataSet

final class CollectionViewSnapshotDataSet<Cell>: CollectionViewDelegate,
                                                 CollectionViewDataSource,
                                                 CollectionViewDataSourcePrefetching
where Cell: UICollectionViewCell {
    
    // MARK: Properties
    
    var section: Section
    
    var cache: NSCache<NSString, UIImage> {
        AsyncImageFetcher.shared.cache
    }
    
    weak var standardCell: TableViewCell<Cell>! = nil
    
    var viewModel: DefaultHomeViewModel!
    
    init(_ section: Section, viewModel: DefaultHomeViewModel? = nil) {
        self.section = section
        if let viewModel = viewModel {
            self.viewModel = viewModel
        }
    }
    
    convenience init(_ section: Section, viewModel: DefaultHomeViewModel, standardCell: TableViewCell<Cell>) {
        self.init(section, viewModel: viewModel)
        self.standardCell = standardCell
    }
    
    deinit {
        standardCell = nil
        viewModel = nil
    }
    
    
    // MARK: CollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let indices = TableViewDataSource.Indices(rawValue: self.section.id) else { return .zero }
        switch indices {
        case .display,
                .ratable,
                .resumable:
            return viewModel.state.value == .tvShows
                ? viewModel.sections.value.first!.tvshows!.count
                : viewModel.sections.value.first!.movies!.count
        default:
            guard let standardCell = standardCell else { return .zero }
            return viewModel.state.value == .tvShows
                ? standardCell.section.tvshows!.count
                : standardCell.section.movies!.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> CollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
            fatalError("Could not dequeue cell \(Cell.self)")
        }
        return self.collectionView(collectionView, willConfigure: cell, forItemAt: indexPath)!
    }
    
    func collectionView(_ collectionView: UICollectionView, willConfigure cell: CollectionViewCell, forItemAt indexPath: IndexPath) -> CollectionViewCell? {
        guard
            let media = media(for: indexPath)
        else {
            fatalError("Unexpected indexpath for object at \(indexPath).")
        }
        
        var coverURL: URL!
        var logoURL: URL!
        
        switch media.presentedCover {
        case "0":
            coverURL = URL(string: media.covers.first!)!
        case "1":
            coverURL = URL(string: media.covers[1])!
        case "2":
            coverURL = URL(string: media.covers[2])!
        case "3":
            coverURL = URL(string: media.covers[3])!
        case "4":
            coverURL = URL(string: media.covers[4])!
        case "5":
            coverURL = URL(string: media.covers[5])!
        default:
            break
        }
        
        switch media.presentedLogo {
        case "0":
            logoURL = URL(string: media.logos.first!)!
        case "1":
            logoURL = URL(string: media.logos[1])!
        case "2":
            logoURL = URL(string: media.logos[2])!
        case "3":
            logoURL = URL(string: media.logos[3])!
        case "4":
            logoURL = URL(string: media.logos[4])!
        case "5":
            logoURL = URL(string: media.logos[5])!
        case "6":
            logoURL = URL(string: media.logos[6])!
        default:
            break
        }
        
        guard
            let identifier = "cover_\(media.slug)" as NSString?,
            let logoIdentifier = "logo_\(media.slug)" as NSString?,
            let coverURL = coverURL,
            let logoURL = logoURL
        else { fatalError("xzc") }
        
        cell.representedIdentifier = media.title as NSString
        
        cell.placeholderLabel.text = media.title
        cell.placeholderLabel.alpha = 1.0
        
        guard
            let cover = cache.object(forKey: identifier),
            let logo = cache.object(forKey: logoIdentifier)
        else {
            cell.configure(section: nil)
            
            AsyncImageFetcher.shared.load(url: coverURL, identifier: identifier) { [weak self] image in
                guard cell.representedIdentifier == media.title as NSString else { return }
                DispatchQueue.main.async {
                    cell.configure(section: self?.section, media: media, cover: image, at: indexPath, with: self?.viewModel)
                    cell.placeholderLabel.alpha = 0.0
                }
            }
            
            AsyncImageFetcher.shared.load(url: logoURL, identifier: logoIdentifier) { [weak self] image in
                guard cell.representedIdentifier == media.title as NSString else { return }
                DispatchQueue.main.async {
                    cell.configure(section: self?.section, media: media, logo: image, at: indexPath, with: self?.viewModel)
                }
            }
            
            return cell
        }
        
        cell.configure(section: section, media: media, cover: cover, logo: logo, at: indexPath, with: viewModel)
        
        return cell
    }
    
    
    // MARK: CollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: CollectionViewCell, forItemAt indexPath: IndexPath) {
        guard
            let media = media(for: indexPath),
            let identifier = "cover_\(media.slug)" as NSString?,
            let logoIdentifier = "logo_\(media.slug)" as NSString?
        else {
            fatalError("Unexpected indexpath for object at \(indexPath).")
        }
        if let cover = cache.object(forKey: identifier),
           let logo = cache.object(forKey: logoIdentifier) {
            DispatchQueue.main.async {
                cell.coverImageView.image = cover
                cell.logoImageView.image = logo
            }
            cell.placeholderLabel.alpha = 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: CollectionViewCell, forItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            cell.coverImageView.image = nil
            cell.logoImageView.image = nil
            cell.placeholderLabel.text = nil
            cell.placeholderLabel.alpha = 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, with viewModel: DefaultHomeViewModel) {}
    
    // MARK: CollectionViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard
                let media = media(for: indexPath)
            else {
                fatalError("Unexpected indexpath for object at \(indexPath).")
            }

            var coverURL: URL!
            var logoURL: URL!

            switch media.presentedCover {
            case "0":
                coverURL = URL(string: media.covers.first!)!
            case "1":
                coverURL = URL(string: media.covers[1])!
            case "2":
                coverURL = URL(string: media.covers[2])!
            case "3":
                coverURL = URL(string: media.covers[3])!
            case "4":
                coverURL = URL(string: media.covers[4])!
            case "5":
                coverURL = URL(string: media.covers[5])!
            default:
                break
            }

            switch media.presentedLogo {
            case "0":
                logoURL = URL(string: media.logos.first!)!
            case "1":
                logoURL = URL(string: media.logos[1])!
            case "2":
                logoURL = URL(string: media.logos[2])!
            case "3":
                logoURL = URL(string: media.logos[3])!
            case "4":
                logoURL = URL(string: media.logos[4])!
            case "5":
                logoURL = URL(string: media.logos[5])!
            case "6":
                logoURL = URL(string: media.logos[6])!
            default:
                break
            }

            guard
                let coverIdentifier = "cover_\(media.slug)" as NSString?,
                let logoIdentifier = "logo_\(media.slug)" as NSString?,
                let coverURL = coverURL,
                let logoURL = logoURL
            else { fatalError("xzc") }
            AsyncImageFetcher.shared.load(url: coverURL, identifier: coverIdentifier) { _ in }
            AsyncImageFetcher.shared.load(url: logoURL, identifier: logoIdentifier) { _ in }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {}
    
    
    // MARK: Private Methods
    
    private func media(for indexPath: IndexPath) -> Media? {
        if let standardCell = standardCell {
            return viewModel.state.value == .tvShows
                ? standardCell.section.tvshows![indexPath.row] as Media?
                : standardCell.section.movies![indexPath.row] as Media?
        }
        
        return viewModel.state.value == .tvShows
            ? viewModel.sections.value.first!.tvshows![indexPath.row] as Media?
            : viewModel.sections.value.first!.movies![indexPath.row] as Media?
    }
}



// MARK: - CollectionViewSnapshot

final class CollectionViewSnapshot<Cell, DataSet: CollectionViewDelegate
                                    & CollectionViewDataSource
                                    & CollectionViewDataSourcePrefetching>:
                                        NSObject,
                                        UICollectionViewDelegate,
                                        UICollectionViewDataSource,
                                        UICollectionViewDataSourcePrefetching {
    
    var dataSet: DataSet
    
    var viewModel: DefaultHomeViewModel
    
    init(_ dataSet: DataSet,
         _ viewModel: DefaultHomeViewModel) {
        self.dataSet = dataSet
        self.viewModel = viewModel
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dataSet.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dataSet.collectionView(collectionView, willDisplay: cell as! CollectionViewCell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard type(of: cell) == UICollectionViewCell.self else { return }
        dataSet.collectionView(collectionView, didEndDisplaying: cell as! CollectionViewCell, forItemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSet.collectionView(collectionView, didSelectItemAt: indexPath, with: viewModel)
    }
    
    
    // MARK: UICollectionViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        dataSet.collectionView(collectionView, prefetchItemsAt: indexPaths)
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        dataSet.collectionView(collectionView, cancelPrefetchingForItemsAt: indexPaths)
    }
}
