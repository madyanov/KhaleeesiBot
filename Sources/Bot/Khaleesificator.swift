import Foundation

final class Khaleesificator {
    private let rules: [String: String] = [
        "а": "я",
        "ъ": "ь",
        "р": "й",
        "л": "й",
        "у": "ю",
        "ч": "с",
        "щ": "с",
        "ж": "з",
    ]

    func khaleesificate(text: String) -> String {
        var text = text

        for rule in rules {
            text = text.replacingOccurrences(of: rule.key, with: rule.value)
            text = text.replacingOccurrences(of: rule.key.uppercased(), with: rule.value.uppercased())
        }

        return text
    }
}
