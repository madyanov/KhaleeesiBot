import Foundation
import Api
import Bot

guard let token = ProcessInfo.processInfo.environment["KHALEEESI_TOKEN"] else {
    fatalError("No token in KHALEEESI_TOKEN environment variable")
}

guard let config: Config = loadConfig(name: "config") else {
    fatalError("Can't load config")
}

let wordScores: [String: Float] = loadConfig(name: "word-scores") ?? [:]

let apiConfig = Api.Config(endpoint: config.endpoint, token: token)
let api = Api(config: apiConfig)


let botConfig = Bot.Config(trigger: config.trigger, wordScores: wordScores)
let bot = Bot(api: api, config: botConfig)

RunLoop.main.run()
