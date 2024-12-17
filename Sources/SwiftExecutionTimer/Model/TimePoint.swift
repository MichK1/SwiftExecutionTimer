//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation

/// TimePoint represents point in time
public struct TimePoint: Equatable {
    /// Specifies the time in seconds from a chosen reference point (e.g., system boot time or Unix epoch).
    public let timePoint: Double
    /// A label describing the time point.
    public let label: String
    
    /// Initializes a `TimePoint` with a specified time and label.
    ///
    /// - Parameters:
    ///   - timePoint: The time in seconds from a chosen reference point.
    ///   - label: A label describing the `TimePoint`.
    public init(timePoint: Double, label: String) {
        self.timePoint = timePoint
        self.label = label
    }
}
