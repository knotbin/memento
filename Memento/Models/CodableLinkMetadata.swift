//
//  CodableLinkMetadata.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/30/24.
//

import Foundation
import LinkPresentation

struct CodableLinkMetadata: Codable {
    var originalURL: URL?
    var url: URL?
    var title: String?
    var remoteVideoURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case originalURL
        case url
        case title
        case remoteVideoURL
    }
    
    init(metadata: LPLinkMetadata) {
        self.originalURL = metadata.originalURL
        self.url = metadata.url
        self.title = metadata.title
        self.remoteVideoURL = metadata.remoteVideoURL
    }
    
    func toLPLinkMetadata() -> LPLinkMetadata {
        let metadata = LPLinkMetadata()
        metadata.originalURL = self.originalURL
        metadata.url = self.url
        metadata.title = self.title
        metadata.remoteVideoURL = self.remoteVideoURL
        return metadata
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.originalURL = try container.decodeIfPresent(URL.self, forKey: .originalURL)
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.remoteVideoURL = try container.decodeIfPresent(URL.self, forKey: .remoteVideoURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(originalURL, forKey: .originalURL)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(remoteVideoURL, forKey: .remoteVideoURL)
    }
}
