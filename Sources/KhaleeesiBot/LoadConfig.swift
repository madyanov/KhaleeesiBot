import Foundation

func loadConfig<Config: Decodable>(name: String) -> Config? {
    guard let path = Bundle.module.path(forResource: name, ofType: "json") else { return nil }
    guard let data = FileManager.default.contents(atPath: path) else { return nil }
    return try? JSONDecoder().decode(Config.self, from: data)
}
