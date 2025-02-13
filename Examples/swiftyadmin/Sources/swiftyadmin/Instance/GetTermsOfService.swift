import ArgumentParser
import Foundation
import TootSDK

struct GetInstanceTermsOfService: AsyncParsableCommand {

    @Option(name: .shortAndLong, help: "URL to the instance to connect to")
    var url: String

    mutating func run() async throws {
        let client = TootClient(instanceURL: URL(string: url)!)
        try await client.connect()
        let instance = try await client.getTermsOfService()
        print(instance)
    }
}
