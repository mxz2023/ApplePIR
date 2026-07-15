import Foundation
import IdentityLookup

/// Local development extension for Apple's Live Caller ID Lookup API.
///
/// The service and token issuer intentionally point at the same local PIR
/// server. Direct Xcode-installed builds may use HTTP and a custom port for
/// local testing; production/distribution builds require Apple's relay and
/// endpoint validation.
@main
struct LiveCallerIDLookupExtension: LiveCallerIDLookupProtocol {
    var context: LiveCallerIDLookupExtensionContext {
        LiveCallerIDLookupExtensionContext(
            serviceURL: URL(string: "http://192.168.31.219:8080")!,
            tokenIssuerURL: URL(string: "http://192.168.31.219:8080")!,
            userTierToken: Data(base64Encoded: "BBBB")!
        )
    }
}
