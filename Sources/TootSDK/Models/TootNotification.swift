// Created by konstantin on 02/11/2022
// Copyright (c) 2022. All rights reserved.

import Foundation

/// Represents a notification of an event relevant to the user.
public struct TootNotification: Decodable, Hashable, Identifiable, Sendable {
    public init(
        id: String,
        type: TootNotification.NotificationType,
        account: Account,
        createdAt: Date,
        post: Post? = nil,
        report: Report? = nil,
        relationshipSeveranceEvent: RelationshipSeveranceEvent? = nil
    ) {
        self.id = id
        self.type = type
        self.account = account
        self.createdAt = createdAt
        self.post = post
        self.report = report
        self.relationshipSeveranceEvent = relationshipSeveranceEvent
    }

    /// The id of the notification in the database.
    public var id: String
    /// The type of event that resulted in the notification.
    public var type: NotificationType
    /// The account that performed the action that generated the notification.
    public var account: Account
    /// The timestamp of the notification.
    public var createdAt: Date
    /// Post that was the object of the notification, e.g. in mentions, reposts, favourites, or polls.
    public var post: Post?
    /// Report that was the object of the notification. Attached when type of the notification is ``NotificationType/adminReport``.
    public var report: Report?
    /// Summary of the event that caused follow relationships to be severed. Attached when type of the notification is ``NotificationType/severedRelationships``.
    public var relationshipSeveranceEvent: RelationshipSeveranceEvent?

    public enum NotificationType: Decodable, Hashable, Sendable, CaseIterable {
        /// Someone followed you
        case follow
        /// Someone mentioned you in their post
        case mention
        /// Someone reposted one of your posts
        case repost
        /// Someone favourited one of your posts
        case favourite
        /// A poll you have voted in or created has ended
        case poll
        /// Someone requested to follow you
        case followRequest
        /// Someone you enabled notifications for has posted a post
        case post
        /// A post you interacted with has been edited
        case update
        /// Someone signed up
        case adminSignUp
        /// A new report has been filed
        case adminReport
        /// Some of your follow relationships have been severed as a result of a moderation or block event
        case severedRelationships
        /// Someone reacted with emoji to one of your posts
        case emojiReaction

        /// An unsupported notification type was received. If you encounter this please update TootSDK by adding support for received type.
        case unknown(String)

        public init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            let rawValue = try container.decode(String.self)
            self = NotificationType(rawValue: rawValue)
        }

        public init(rawValue: String) {
            switch rawValue {
            case "follow":
                self = .follow
            case "mention":
                self = .mention
            case "reblog":
                self = .repost
            case "favourite":
                self = .favourite
            case "poll":
                self = .poll
            case "follow_request":
                self = .followRequest
            case "status":
                self = .post
            case "update":
                self = .update
            case "admin.sign_up":
                self = .adminSignUp
            case "admin.report":
                self = .adminReport
            case "severed_relationships":
                self = .severedRelationships
            case "emoji_reaction", "pleroma:emoji_reaction":
                self = .emojiReaction
            default:
                self = .unknown(rawValue)
            }
        }

        public func rawValue(flavour: TootSDKFlavour) -> String {
            switch self {
            case .follow: return "follow"
            case .mention: return "mention"
            case .repost: return "reblog"
            case .favourite: return "favourite"
            case .poll: return "poll"
            case .followRequest: return "follow_request"
            case .post: return "status"
            case .update: return "update"
            case .adminSignUp: return "admin.sign_up"
            case .adminReport: return "admin.report"
            case .severedRelationships: return "severed_relationships"
            case .emojiReaction:
                if flavour == .pleroma || flavour == .akkoma {
                    return "pleroma:emoji_reaction"
                }
                return "emoji_reaction"
            case .unknown(let rawValue): return rawValue
            }
        }

        public static var allCases: [TootNotification.NotificationType] {
            return [
                .follow,
                .mention,
                .repost,
                .favourite,
                .poll,
                .followRequest,
                .post,
                .update,
                .adminSignUp,
                .adminReport,
                .severedRelationships,
                .emojiReaction,
            ]
        }

        /// Returns notification types supported by the given `flavour`.
        public static func supported(by flavour: TootSDKFlavour) -> Set<NotificationType> {
            switch flavour {
            case .mastodon:
                return [
                    .follow, .mention, .repost, .favourite, .poll, .followRequest, .post, .update, .adminSignUp, .adminReport, .severedRelationships,
                ]
            case .pleroma, .akkoma:
                return [.follow, .mention, .repost, .favourite, .poll, .followRequest, .update, .emojiReaction]
            case .friendica:
                return [.follow, .mention, .repost, .favourite, .poll]
            case .pixelfed:
                return [.follow, .mention, .repost, .favourite]
            case .firefish, .catodon, .iceshrimp:
                return [.follow, .mention, .repost, .poll, .followRequest]
            case .goToSocial:
                return [.follow, .followRequest, .mention, .repost, .favourite, .poll, .post, .adminSignUp]
            case .sharkey:
                return [
                    .follow, .mention, .repost, .favourite, .poll, .followRequest, .post, .update, .adminSignUp, .adminReport, .severedRelationships,
                    .emojiReaction,
                ]
            }
        }

        /// Returns push notification types supported by the given `flavour`.
        public static func supportedAsPush(by flavour: TootSDKFlavour) -> Set<NotificationType> {
            switch flavour {
            case .mastodon:
                return Set(allCases)
            case .pleroma, .akkoma, .friendica, .sharkey:
                return [.follow, .mention, .repost, .favourite, .poll]
            case .pixelfed, .firefish, .goToSocial, .catodon, .iceshrimp:
                return []
            }
        }

        /// Returns true if this notification type is supported by the given `flavour`.
        public func isSupported(by flavour: TootSDKFlavour) -> Bool {
            return Self.supported(by: flavour).contains(self)
        }

        /// Returns true if this notification type is supported as push notification by the given `flavour`.
        public func isSupportedAsPush(by flavour: TootSDKFlavour) -> Bool {
            return Self.supportedAsPush(by: flavour).contains(self)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case type
        case account
        case createdAt
        case post = "status"
        case report
        case relationshipSeveranceEvent = "relationship_severance_event"
    }
}

extension TootNotification.NotificationType: Identifiable {
    public var id: Self { self }
}
