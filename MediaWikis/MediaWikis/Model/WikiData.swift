//
//  WikiData.swift
//  MediaWikis
//
//  Created by Astha Ameta on 8/16/21.
//

import Foundation

struct WikiData: Codable {
    let batchcomplete: String
    let welcomeContinue: Continue
    let query: Query

    enum CodingKeys: String, CodingKey {
        case batchcomplete
        case welcomeContinue = "continue"
        case query
    }
}

struct Query: Codable {
    let pages: [String: Page]
}

struct Page: Codable {
    let pageid, ns: Int
    let title: String
    let index: Int
    let thumbnail: Thumbnail?
}

struct Thumbnail: Codable {
    let source: String
    let width, height: Int
}

struct Continue: Codable {
    let gpsoffset: Int
    let continueContinue: String

    enum CodingKeys: String, CodingKey {
        case gpsoffset
        case continueContinue = "continue"
    }
}

struct DataFromFile: Codable {
    let t: [Thumbnail]

}

