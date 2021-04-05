final class MoodAnalyzer {
    private let wordScores: [String: Float]

    init(wordScores: [String: Float]) {
        self.wordScores = wordScores
    }

    func analyzeMood(text: String) -> Float {
        let words = text.lowercased().components(separatedBy: .whitespacesAndNewlines)
        var score: Float = 0

        for word in words {
            score += wordScores
                .first { word.contains($0.key) }?
                .value ?? 0
        }

        return score / Float(words.count)
    }
}
