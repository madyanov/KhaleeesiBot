public final class Message: Decodable {
    public let date: Int
    public let chat: Chat
    public let replyToMessage: Message?
    public let text: String?
}
