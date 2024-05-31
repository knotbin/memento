//
//  FetchMetadata.swift
//  ShareSheet
//
//  Created by Roscoe Rubin-Rottenberg on 5/31/24.
//

import Foundation
import LinkPresentation

public func fetchMetadata(url: URL) async -> LPLinkMetadata {
    let provider = LPMetadataProvider()
    
    return await withCheckedContinuation { continuation in
        provider.startFetchingMetadata(for: url) { (metadata, error) in
            if let metadata = metadata {
                continuation.resume(returning: metadata)
            } else if let error = error {
                print("Error fetching metadata: \(error)")
                continuation.resume(returning: LPLinkMetadata()) // Return an empty metadata object in case of error
            } else {
                continuation.resume(returning: LPLinkMetadata()) // Return an empty metadata object if metadata is nil
            }
        }
    }
}
