//
//  NotificationFallback.swift
//  TootSDK
//
//  Created by Lukasz Rutkowski on 07/06/2026.
//

import Foundation

/// Represents a notification of an event relevant to the user.
public struct NotificationFallback: Codable, Hashable, Sendable {
    /// Localized fallback title for the notification, for instance “Alice added you to a collection”. (HTML)
    public var title: String
    /// Localized fallback summary for the notification, for instance “You’re on an app that does not support
    /// the most recent version of Mastodon. Sign in to the Mastodon web app for full functionality.” (HTML)
    public var summary: String?
    /// Localized details for the notifications, to be displayed when clicking the notification, for instance. (HTML)
    public var details: String?

    public init(
        title: String,
        summary: String? = nil,
        details: String? = nil
    ) {
        self.title = title
        self.summary = summary
        self.details = details
    }
}
