//
//  FetchMetadata.swift
//  Memento
//
//  Created by Roscoe Rubin-Rottenberg on 5/30/24.
//

import Foundation
import LinkPresentation

public func fetchMetadata(url: URL) async -> LPLinkMetadata {
    let provider = LPMetadataProvider()
    let timeout: UInt64 = 15 * 1_000_000_000 // 15 seconds in nanoseconds

    return await withCheckedContinuation { (continuation: CheckedContinuation<LPLinkMetadata, Never>) in
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
        
        Task {
            try? await Task.sleep(nanoseconds: timeout)
            continuation.resume(returning: LPLinkMetadata()) // Return an empty metadata object if timeout occurs
        }
    }
}
