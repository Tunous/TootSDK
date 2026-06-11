//
//  AccountWarning.swift
//  TootSDK
//
//  Created by Lukasz Rutkowski on 07/06/2026.
//

import Foundation

/// Moderation warning against a particular account.
public struct AccountWarning: Codable, Hashable, Identifiable, Sendable {
    /// The ID of the account warning.
    public var id: String
    /// Action taken against the account.
    public var action: OpenEnum<Action>
    /// Message from the moderator to the target account.
    public var text: String
    /// List of post IDs that are relevant to the warning. When action is mark_statuses_as_sensitive or delete_statuses,
    /// those are the affected statuses. If the action is delete_statuses then they have been irrevocably deleted
    /// (irrespective of the appeal state), and will be inaccessible to the client.
    public var postIds: [String]?
    /// Account against which a moderation decision has been taken. If this AccountWarning is present in a Notification
    /// then this is always the same as the authenticated account that requested the notification.
    public var targetAccount: Account
    /// Appeal submitted by the target account, if any.
    public var appeal: Appeal?
    /// When the event took place.
    public var createdAt: Date

    public init(
        id: String,
        action: Action,
        text: String,
        postIds: [String]? = nil,
        targetAccount: Account,
        appeal: Appeal? = nil,
        createdAt: Date
    ) {
        self.id = id
        self.action = .some(action)
        self.text = text
        self.postIds = postIds
        self.targetAccount = targetAccount
        self.appeal = appeal
        self.createdAt = createdAt
    }

    /// Action taken against the account.
    public enum Action: String, Codable, Hashable, Sendable {
        /// No action was taken, this is a simple warning
        case none
        /// The account has been disabled
        case disable
        /// Specific posts from the target account have been marked as sensitive
        case markPostsAsSensitive = "mark_statuses_as_sensitive"
        /// Specific statuses from the target account have been deleted
        case deletePosts = "delete_statuses"
        /// All posts from the target account are marked as sensitive
        case sensitive
        /// The target account has been limited
        case silence
        /// The target account has been suspended
        case suspend
    }

    public enum CodingKeys: String, Codable, CodingKey {
        case id
        case action
        case text
        case postIds = "statusIds"
        case targetAccount
        case appeal
        case createdAt
    }
}
