import Foundation
import LinkPresentation

public func fetchMetadata(url: URL) async -> LPLinkMetadata {
    let provider = LPMetadataProvider()
    let timeout: UInt64 = 15 * 1_000_000_000 // 15 seconds in nanoseconds

    return await withCheckedContinuation { (continuation: CheckedContinuation<LPLinkMetadata, Never>) in
        var resumed = false
        let resumeIfNotResumed = {
            if !resumed {
                resumed = true
                continuation.resume(returning: LPLinkMetadata())
            }
        }
        
        provider.startFetchingMetadata(for: url) { (metadata, error) in
            if let metadata = metadata {
                if !resumed {
                    resumed = true
                    continuation.resume(returning: metadata)
                }
            } else {
                print("Error fetching metadata: \(String(describing: error))")
                resumeIfNotResumed()
            }
        }
        
        Task {
            try? await Task.sleep(nanoseconds: timeout)
            resumeIfNotResumed()
        }
    }
}
