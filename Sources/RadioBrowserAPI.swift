import SwiftUI
import SwiftyBeaver

let log = SwiftyBeaver.self

public class RadioBrowserAPI: ObservableObject {
    internal static let version = "0.1.4"
    internal static let build = 1
    internal static let apiServer = RadioBrowserServer()

    // MARK: - Public API

    public static var httpUserAgent: String = "\(RadioBrowserAPI.self)/\(RadioBrowserAPI.version)"
    public static var apiResponseFormat: ApiResponseFormat = .json

    @Published public internal(set) var stations: [RadioBrowser.Station] = []
    @Published public internal(set) var isLoading: Bool = false

    static var delegate: RadioBrowserDelegate?

    public init(delegate: RadioBrowserDelegate? = nil) {
        RadioBrowserAPI.delegate = delegate

        /// Prefetch all stations by current region code
        stations(byCountryCode: Locale.current.regionCode!, order: .clickCount, reverse: true, limit: 50)
    }
    
    public init(delegate: RadioBrowserDelegate? = nil, _ country: String = Locale.current.regionCode!) {
        RadioBrowserAPI.delegate = delegate

        /// Prefetch all stations by current region code
        stations(byCountryCode: country, order: .clickCount, reverse: true, limit: 50)
    }
}

public protocol RadioBrowserDelegate {
    func radioBrowser(willStartRequest: URLRequest)
    func radioBrowser(endRequest: URLRequest, withError: Error)
    func radioBrowser(_ radioBrowser: RadioBrowserAPI, receivedStations: [RadioBrowser.Station])
    func radioBrowser(_ radioBrowser: RadioBrowserAPI, receivedConfig: RadioBrowser.Config)
    func radioBrowser(_ radioBrowser: RadioBrowserAPI, didUpdateClickCount: RadioBrowser.ClickCount)
}
