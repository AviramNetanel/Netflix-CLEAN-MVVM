//
//  CollectionViewDataSource.swift
//  netflix
//
//  Created by Zach Bazov on 13/09/2022.
//

import UIKit

// MARK: - CollectionViewDataSource

final class CollectionViewDataSource<Cell>: NSObject,
                                            UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDataSourcePrefetching where Cell: UICollectionViewCell {
    
    var section: Section
    var viewModel: DefaultHomeViewModel
    
    var standardCell: TableViewCell<Cell>!
    
    var cache: NSCache<NSString, UIImage> { AsyncImageFetcher.shared.cache }
    
    init(_ section: Section, viewModel: DefaultHomeViewModel) {
        self.section = section
        self.viewModel = viewModel
    }
    
    convenience init(_ section: Section,
                     viewModel: DefaultHomeViewModel,
                     standardCell: TableViewCell<Cell>) {
        self.init(section, viewModel: viewModel)
        self.standardCell = standardCell
    }
    
    deinit {
        standardCell = nil
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? CollectionViewCell
        else { fatalError() }
        
        guard let media = media(for: indexPath) else { fatalError() }
        
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
        else { fatalError() }
        
        cell.representedIdentifier = media.title as NSString
        
        cell.placeholderLabel.text = media.title
        cell.placeholderLabel.alpha = 1.0
        
        guard
            let cover = cache.object(forKey: identifier),
            let logo = cache.object(forKey: logoIdentifier)
        else {
            cell.configure(section: nil)
            
            AsyncImageFetcher.shared.load(url: coverURL,
                                          identifier: identifier) { [weak self] image in
                guard cell.representedIdentifier == media.title as NSString else { return }
                DispatchQueue.main.async {
                    cell.configure(section: self?.section,
                                   media: media,
                                   cover: image,
                                   at: indexPath,
                                   with: self?.viewModel)
                    cell.placeholderLabel.alpha = 0.0
                }
            }
            
            AsyncImageFetcher.shared.load(url: logoURL,
                                          identifier: logoIdentifier) { [weak self] image in
                guard cell.representedIdentifier == media.title as NSString else { return }
                DispatchQueue.main.async {
                    cell.configure(section: self?.section,
                                   media: media,
                                   logo: image,
                                   at: indexPath,
                                   with: self?.viewModel)
                }
            }
            
            return cell
        }
        
        cell.configure(section: section,
                       media: media,
                       cover: cover,
                       logo: logo,
                       at: indexPath,
                       with: viewModel)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard
            let cell = cell as? CollectionViewCell,
            let media = media(for: indexPath),
            let identifier = "cover_\(media.slug)" as NSString?,
            let logoIdentifier = "logo_\(media.slug)" as NSString?
        else { fatalError() }
        
        guard
            let cover = cache.object(forKey: identifier),
            let logo = cache.object(forKey: logoIdentifier)
        else { return }
        DispatchQueue.main.async {
            cell.coverImageView.image = cover
            cell.logoImageView.image = logo
        }
        cell.placeholderLabel.alpha = 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CollectionViewCell else { return }
        DispatchQueue.main.async {
            cell.coverImageView.image = nil
            cell.logoImageView.image = nil
            cell.placeholderLabel.text = nil
            cell.placeholderLabel.alpha = 0.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {}
    
    // MARK: UICollectionViewDataSourcePrefetching
    
    func collectionView(_ collectionView: UICollectionView,
                        prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            guard let media = media(for: indexPath) else { fatalError() }
            
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
            else { fatalError() }
            AsyncImageFetcher.shared.load(url: coverURL, identifier: coverIdentifier) { _ in }
            AsyncImageFetcher.shared.load(url: logoURL, identifier: logoIdentifier) { _ in }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {}
    
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
