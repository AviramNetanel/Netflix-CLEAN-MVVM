//
//  MediaEntity+Mapping.swift
//  netflix
//
//  Created by Zach Bazov on 19/10/2022.
//

import Foundation

// MARK: - MediaEntity class

@objc(MediaEntity)
public final class MediaEntity: NSObject, Codable, NSSecureCoding {
    
    var id: String?
    var type: String?
    var title: String?
    var slug: String?
    
    var createdAt: String?
    
    var rating: Float?
    var desc: String?
    var cast: String?
    var writers: String?
    var duration: String?
    var length: String?
    var genres: [String]?
    
    var hasWatched: Bool?
    var isHD: Bool?
    var isExclusive: Bool?
    var isNewRelease: Bool?
    var isSecret: Bool?
    
    var resources: MediaResourcesDTO?
    
    var seasons: [String]?
    var numberOfEpisodes: Int?
    
    init(id: String?,
         type: String,
         title: String,
         slug: String,
         createdAt: String,
         rating: Float,
         description: String,
         cast: String,
         writers: String,
         duration: String,
         length: String,
         genres: [String],
         hasWatched: Bool,
         isHD: Bool,
         isExclusive: Bool,
         isNewRelease: Bool,
         isSecret: Bool,
         resources: MediaResourcesDTO,
         seasons: [String]?,
         numberOfEpisodes: Int?) {
        self.id = id
        self.type = type
        self.title = title
        self.slug = slug
        self.createdAt = createdAt
        self.rating = rating
        self.desc = description
        self.cast = cast
        self.writers = writers
        self.duration = duration
        self.length = length
        self.genres = genres
        self.hasWatched = hasWatched
        self.isHD = isHD
        self.isExclusive = isExclusive
        self.isNewRelease = isNewRelease
        self.isSecret = isSecret
        self.resources = resources
        self.seasons = seasons
        self.numberOfEpisodes = numberOfEpisodes
    }
    
    // MARK: NSSecureCoding
    
    public static var supportsSecureCoding: Bool { true }
    
    public init?(coder: NSCoder) {
        self.id = coder.decodeObject(of: NSString.self, forKey: "id") as? String
        self.type = coder.decodeObject(of: NSString.self, forKey: "type") as? String
        self.title = coder.decodeObject(of: NSString.self, forKey: "title") as? String
        self.slug = coder.decodeObject(of: NSString.self, forKey: "slug") as? String
        self.createdAt = coder.decodeObject(of: NSString.self, forKey: "createdAt") as? String
        self.rating = coder.decodeFloat(forKey: "rating")
        self.desc = coder.decodeObject(of: NSString.self, forKey: "desc") as? String
        self.cast = coder.decodeObject(of: NSString.self, forKey: "cast") as? String
        self.writers = coder.decodeObject(of: NSString.self, forKey: "writers") as? String
        self.duration = coder.decodeObject(of: NSString.self, forKey: "duration") as? String
        self.length = coder.decodeObject(of: NSString.self, forKey: "length") as? String
        self.genres = coder.decodeObject(of: NSArray.self, forKey: "genres") as? [String]
        self.hasWatched = coder.decodeBool(forKey: "hasWatched")
        self.isHD = coder.decodeBool(forKey: "isHD")
        self.isExclusive = coder.decodeBool(forKey: "isExclusive")
        self.isNewRelease = coder.decodeBool(forKey: "isNewRelease")
        self.isSecret = coder.decodeBool(forKey: "isSecret")
        self.resources = coder.decodeObject(of: MediaResourcesDTO.self, forKey: "resources")
        self.seasons = coder.decodeObject(of: NSArray.self, forKey: "seasons") as? [String]
        self.numberOfEpisodes = Int(coder.decodeInt32(forKey: "numberOfEpisodes"))
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(type, forKey: "type")
        coder.encode(title, forKey: "title")
        coder.encode(slug, forKey: "slug")
        coder.encode(createdAt, forKey: "createdAt")
        coder.encode(rating, forKey: "rating")
        coder.encode(desc, forKey: "desc")
        coder.encode(cast, forKey: "cast")
        coder.encode(writers, forKey: "writers")
        coder.encode(duration, forKey: "duration")
        coder.encode(length, forKey: "length")
        coder.encode(genres, forKey: "genres")
        coder.encode(hasWatched, forKey: "hasWatched")
        coder.encode(isHD, forKey: "isHD")
        coder.encode(isExclusive, forKey: "isExclusive")
        coder.encode(isNewRelease, forKey: "isNewRelease")
        coder.encode(isSecret, forKey: "isSecret")
        coder.encode(resources, forKey: "resources")
        coder.encode(seasons, forKey: "seasons")
        coder.encode(numberOfEpisodes, forKey: "numberOfEpisodes")
    }
}

// MARK: - Mapping

extension MediaEntity {
    func toDTO() -> MediaDTO {
        return .init(
            id: id,
            type: type!,
            title: title!,
            slug: slug!,
            createdAt: createdAt!,
            rating: rating!,
            description: desc!,
            cast: cast!,
            writers: writers,
            duration: duration,
            length: length!,
            genres: genres!,
            hasWatched: hasWatched!,
            isHD: isHD!,
            isExclusive: isExclusive!,
            isNewRelease: isNewRelease!,
            isSecret: isSecret!,
            resources: resources!,
            seasons: seasons,
            numberOfEpisodes: numberOfEpisodes)
    }
}
