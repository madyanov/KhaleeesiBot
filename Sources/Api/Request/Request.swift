import Foundation

final class Request<Input: Encodable, Output: Decodable> {
    private var strongSelf: Request?

    @discardableResult
    init(url: URL, httpMethod: HTTPMethod<Input>, completion: @escaping (Result<Output, Error>) -> Void) {
        guard let request = makeRequest(url: url, httpMethod: httpMethod) else {
            assertionFailure("Can't start Request")
            return
        }

        strongSelf = self

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                self.complete { completion(.failure(RequestError.network(error))) }
                return
            }

            guard let data = data else {
                self.complete { completion(.failure(RequestError.noData)) }
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            do {
                let output = try decoder.decode(Output.self, from: data)
                self.complete { completion(.success(output)) }
            } catch {
                self.complete { completion(.failure(RequestError.decode(error))) }
            }
        }

        task.resume()
    }
}

private extension Request {
    func complete(_ work: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.strongSelf = nil
            work()
        }
    }

    func makeRequest(url: URL, httpMethod: HTTPMethod<Input>) -> URLRequest? {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)

        switch httpMethod {
        case .get(let input):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase

            let dict = try? JSONSerialization.jsonObject(with: try encoder.encode(input)) as? [String: Any]
            components?.queryItems = dict?.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        default:
            break
        }

        guard let url = components?.url else { return nil }

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        switch httpMethod {
        case .get:
            request.httpMethod = "GET"
        case .post(let input):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase

            request.httpMethod = "POST"
            request.httpBody = try? encoder.encode(input)
        }

        return request
    }
}
