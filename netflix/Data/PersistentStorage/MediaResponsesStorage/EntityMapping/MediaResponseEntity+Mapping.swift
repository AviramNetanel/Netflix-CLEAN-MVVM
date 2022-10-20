//
//  MediaResponseEntity+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 20/10/2022.
//

import Foundation

// MARK: - MediaResponseEntity extension

extension MediaResponseEntity {
    
    func toDTO() -> MediaResponseDTO {
        let resources = MediaResourcesDTO(
            posters: resources!.posters,
            logos: resources!.logos,
            trailers: resources?.trailers ?? [],
            displayPoster: resources!.displayPoster,
            displayLogos: resources!.displayLogos,
            previewPoster: resources!.previewPoster,
            previewUrl: resources?.previewUrl ?? "",
            presentedPoster: resources!.presentedPoster,
            presentedLogo: resources!.presentedLogo,
            presentedDisplayLogo: resources!.presentedDisplayLogo,
            presentedLogoAlignment: resources!.presentedLogoAlignment)
        let media = MediaDTO(
            id: id,
            type: type!,
            title: title!,
            slug: slug!,
            createdAt: createdAt!,
            rating: rating,
            description: description,
            cast: cast!,
            writers: writers,
            duration: duration,
            length: length!,
            genres: genres!.compactMap { NSString(string: $0) as String },
            hasWatched: hasWatched,
            isHD: isHD,
            isExclusive: isExclusive,
            isNewRelease: isNewRelease,
            isSecret: isSecret,
            resources: resources,
            seasons: seasons,
            numberOfEpisodes: Int(numberOfEpisodes))
        return .init(status: .init(), data: media)
    }
}
