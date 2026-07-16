import Foundation
import IdentityLookup

private enum SharedConfiguration {
    static let appGroupIdentifier = "group.com.jdjr.samplecode.SwiftBloomFilter"
    static let pirServerURLKey = "liveCallerID.pirServerURL"
    static let defaultServerURL = URL(string: "http://127.0.0.1:8080")!

    static var serverURL: URL {
        sharedURL(forKey: pirServerURLKey) ?? defaultServerURL
    }

    private static func sharedURL(forKey key: String) -> URL? {
        guard let value = UserDefaults(suiteName: appGroupIdentifier)?.string(forKey: key),
              let url = URL(string: value),
              let scheme = url.scheme,
              scheme == "http" || scheme == "https",
              url.host != nil else {
            return nil
        }
        return url
    }
}

/// Local development extension for Apple's Live Caller ID Lookup API.
///
/// The service and token issuer follow the URLFilter settings shared by the
/// containing app. Direct Xcode-installed builds may use HTTP and a custom port
/// for local testing; production/distribution builds require Apple's relay and
/// endpoint validation.
@main
struct LiveCallerIDLookupExtension: LiveCallerIDLookupProtocol {
    var context: LiveCallerIDLookupExtensionContext {
        LiveCallerIDLookupExtensionContext(
            serviceURL: SharedConfiguration.serverURL,
            tokenIssuerURL: SharedConfiguration.serverURL,
            userTierToken: Data(base64Encoded: "R2VtaW5p")!
        )
    }
}
