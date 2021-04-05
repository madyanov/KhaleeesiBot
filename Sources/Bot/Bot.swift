import Foundation
import Api

public final class Bot {
    public struct Config {
        let trigger: String
        let wordScores: [String: Float]

        public init(trigger: String, wordScores: [String: Float]) {
            self.trigger = trigger
            self.wordScores = wordScores
        }
    }

    private let api: Api
    private let config: Config

    private lazy var khaleesificator = Khaleesificator()
    private lazy var moodAnalyzer = MoodAnalyzer(wordScores: self.config.wordScores)

    private var lastOffset: Int?
    private var getUpdatesFinished = true

    public init(api: Api, config: Config) {
        self.api = api
        self.config = config

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.poll() }
    }
}

private extension Bot {
    func poll() {
        guard getUpdatesFinished else { return }

        getUpdatesFinished = false

        api.getUpdates(offset: lastOffset.map { $0 + 1 }) {
            switch $0 {
            case .success(let updates):
                self.lastOffset = updates.result.last?.updateId
                let messages = updates.result.compactMap { $0.message }

                if let message = self.findTriggerMessage(in: messages) ?? self.findBadMessage(in: messages),
                   let text = message.text,
                   text.isEmpty == false {

                    self.api.sendMessage(chatId: message.chat.id,
                                         text: self.khaleesificator.khaleesificate(text: text),
                                         completion: { _ in })
                }
            case .failure(let error):
                print("Oops \(error)")
                break
            }

            self.getUpdatesFinished = true
        }
    }

    func findTriggerMessage(in messages: [Message]) -> Message? {
        return messages
            .last { $0.text?.lowercased() == config.trigger }?
            .replyToMessage
    }

    func findBadMessage(in messages: [Message]) -> Message? {
        return messages
            .last { $0.text.map { moodAnalyzer.analyzeMood(text: $0) } ?? 0 < 0 }
    }
}
