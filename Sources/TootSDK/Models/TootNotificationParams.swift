//
//  TootNotificationParams.swift
//
//
//  Created by Konstantin on 04/05/2023.
//

import Foundation

public struct TootNotificationParams: Codable, Sendable {

    public init(
        excludeTypes: [TootNotification.NotificationType]? = nil,
        types: [TootNotification.NotificationType]? = nil,
        accountId: String? = nil,
        includeFiltered: Bool? = nil,
        supportedTypes: Set<TootNotification.NotificationType>? = nil,
    ) {
        self.excludeTypes = excludeTypes.map(Set.init)
        self.types = types.map(Set.init)
        self.accountId = accountId
        self.includeFiltered = includeFiltered
        self.supportedTypes = supportedTypes.map(Set.init)
    }

    public init(
        excludeTypes: Set<TootNotification.NotificationType>? = nil,
        types: Set<TootNotification.NotificationType>? = nil,
        accountId: String? = nil,
        includeFiltered: Bool? = nil,
        supportedTypes: Set<TootNotification.NotificationType>? = nil,
    ) {
        self.excludeTypes = excludeTypes
        self.types = types
        self.accountId = accountId
        self.includeFiltered = includeFiltered
        self.supportedTypes = supportedTypes
    }

    public init() {
        self.excludeTypes = nil
        self.types = nil
        self.accountId = nil
        self.includeFiltered = nil
        self.supportedTypes = nil
    }

    /// Types of notifications to exclude from the search results
    public var excludeTypes: Set<TootNotification.NotificationType>?
    /// Types of notifications to include in the search results
    public var types: Set<TootNotification.NotificationType>?
    /// Return only notifications received from the specified account.
    public var accountId: String?
    /// Whether to include notifications filtered by the user’s NotificationPolicy. Defaults to false.
    public var includeFiltered: Bool?
    /// Notification types to not get fallback representation for even when some is available.
    /// Passing this parameter is required to get any notification fallback at all. When this parameter is used,
    /// and a notification which type is not included in supported_types has an available fallback representation,
    /// it will be included in the notification’s fallback attribute.
    public var supportedTypes: Set<TootNotification.NotificationType>?

    enum CodingKeys: String, CodingKey {
        case excludeTypes = "exclude_types"
        case types = "types"
        case accountId = "account_id"
        case includeFiltered = "include_filtered"
        case supportedTypes = "supported_types"
    }
}

extension TootNotificationParams {
    func corrected(for flavour: TootSDKFlavour) -> TootNotificationParams {
        guard flavour == .friendica || flavour == .sharkey else { return self }
        var params = self
        if let types = params.types {
            var correctedExcludeTypes = TootNotification.NotificationType.supported(by: flavour).subtracting(types)
            if let excludeTypes = params.excludeTypes {
                correctedExcludeTypes.formUnion(excludeTypes)
            }
            params.excludeTypes = correctedExcludeTypes
            params.types = nil
        }
        return params
    }
}
