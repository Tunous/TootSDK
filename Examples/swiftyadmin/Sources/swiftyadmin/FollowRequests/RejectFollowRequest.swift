//
//  RejectFollowRequest.swift
//  
//
//  Created by Łukasz Rutkowski on 10/12/2023.
//

import Foundation
import ArgumentParser
import TootSDK

struct RejectFollowRequest: AsyncParsableCommand {
    @OptionGroup var auth: AuthOptions
    @Option var id: String

    mutating func run() async throws {
        let client = try await auth.connect()
        let followRequests = try await client.rejectFollowRequest(id: id)
        print(followRequests)
    }
}
