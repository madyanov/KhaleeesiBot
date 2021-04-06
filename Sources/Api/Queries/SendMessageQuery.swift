struct SendMessageQuery: Encodable {
    let chatId: Int
    let text: String
    let replyToMessageId: Int?
    let allowSendingWithoutReply: Bool?
}
