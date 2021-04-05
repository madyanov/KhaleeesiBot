import Foundation

struct Config: Decodable {
    let endpoint: URL
    let token: String
    let trigger: String
}
