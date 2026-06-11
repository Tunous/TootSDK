//
//  Appeal.swift
//  TootSDK
//
//  Created by Lukasz Rutkowski on 07/06/2026.
//

import Foundation

/// Appeal against a moderation action.
public struct Appeal: Codable, Hashable, Sendable {
    /// Text of the appeal from the moderated account to the moderators.
    public var text: String
    /// State of the appeal.
    public var state: OpenEnum<State>

    public init(
        text: String,
        state: State
    ) {
        self.text = text
        self.state = .some(state)
    }

    /// State of the appeal.
    public enum State: String, Codable, Hashable, Sendable {
        /// The appeal has been approved by a moderator
        case approved
        /// The appeal has been rejected by a moderator
        case rejected
        /// The appeal has been submitted, but neither approved nor rejected yet
        case pending
    }
}
