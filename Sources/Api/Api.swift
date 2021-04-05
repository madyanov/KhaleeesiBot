import Foundation

public final class Api {
    public struct Config {
        let endpoint: URL
        let token: String

        public init(endpoint: URL, token: String) {
            self.endpoint = endpoint
            self.token = token
        }
    }

    private let config: Config

    public init(config: Config) {
        self.config = config
    }

    public func getUpdates(offset: Int?, completion: @escaping (Result<Updates, Error>) -> Void) {
        let query = GetUpdatesQuery(offset: offset, timeout: 120)

        Request<GetUpdatesQuery, Updates>(url: endpoint(method: "getUpdates"),
                                          httpMethod: .get(query),
                                          completion: completion)
    }

    public func sendMessage(chatId: Int,
                            text: String,
                            completion: @escaping (Result<Empty, Error>) -> Void) {

        let query = SendMessageQuery(chatId: chatId, text: text)

        Request<SendMessageQuery, Empty>(url: endpoint(method: "sendMessage"),
                                         httpMethod: .post(query),
                                         completion: completion)
    }
}

private extension Api {
    func endpoint(method: String) -> URL {
        return config.endpoint
            .appendingPathComponent("bot" + config.token)
            .appendingPathComponent(method)
    }
}
