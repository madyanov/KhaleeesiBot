enum HTTPMethod<Input: Encodable> {
    case get(Input)
    case post(Input)
}
