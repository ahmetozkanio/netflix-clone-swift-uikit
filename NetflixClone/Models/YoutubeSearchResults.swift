//
//  YoutubeSearchResults.swift
//  NetflixClone
//
//  Created by Ahmet Özkan on 7.10.2023.
//

import Foundation

struct YoutubeSearchResults: Codable {
    let items: [VideoElement]?
}

struct VideoElement: Codable {
    let id: IdVideoElement?
}

struct IdVideoElement: Codable {
    let kind: String?
    let videoId: String?
}
