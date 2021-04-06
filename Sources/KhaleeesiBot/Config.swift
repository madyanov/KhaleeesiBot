import Foundation

struct Config: Decodable {
    let endpoint: URL
    let trigger: String
}
