import Foundation
import Api
import Bot

guard let config: Config = loadConfig(name: "config") else {
    fatalError("Can't load config")
}

let wordScores: [String: Float] = loadConfig(name: "word-scores") ?? [:]

let apiConfig = Api.Config(endpoint: config.endpoint, token: config.token)
let api = Api(config: apiConfig)


let botConfig = Bot.Config(trigger: config.trigger, wordScores: wordScores)
let bot = Bot(api: api, config: botConfig)

RunLoop.main.run()
