//
//  RandomPhoto.swift
//  SeSACWeek1617
//
//  Created by 이병현 on 2022/10/24.
//

import Foundation

struct RandomPhoto: Codable, Hashable {
    
    let likes, downloads: Int
    let user: [RandomUser]
    
    enum CodingKeys: String, CodingKey {
        case likes
        case downloads
        case user
    }
}

struct RandomUser: Codable, Hashable {
    let name, location: String
    let totalLikes: Int
    let urls: RandomUrls

    
    enum CodingKeys: String, CodingKey {
        case name
        case location
        case totalLikes = "total_likes"
        case urls
    }
    
}

struct RandomUrls: Codable, Hashable {
    let raw, full, regular, small, thumb: String

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}
