public enum RequestError: Error {
    case network(Error)
    case noData
    case decode(Error)
    case encode(Error)
}
