//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation

/// `Duration` represents a duration of time.
public struct Duration: Equatable {
    /// Duration duration in seconds.
    public let duration: Double
    /// Duration label representing the starting point description.
    public let startLabel: String
    /// Duration label representing the end point description.
    public let endLabel: String
    
    /// Initializes an `Duration` with a duration and labels for the starting and ending points.
    ///
    /// - Parameters:
    ///   - duration: The duration of the duration in seconds.
    ///   - startLabel: The label describing the start of the duration.
    ///   - endLabel: The label describing the end of the duration.
    public init(duration: Double, startLabel: String, endLabel: String) {
        self.duration = duration
        self.startLabel = startLabel
        self.endLabel = endLabel
    }

    /// Initializes an `Duration` struct from two ``TimePoint`` instances.
    ///
    /// Creates an `Duration` where `duration` is the difference between the `end` and `start` time points (`end.timePoint - start.timePoint`).
    ///
    /// - Parameters:
    ///   - start: The starting point of the duration; its label is used as `startLabel`.
    ///   - end: The ending point of the duration; its label is used as `endLabel`.
    public init(start: TimePoint, end: TimePoint) {
        self.duration = end.timePoint - start.timePoint
        self.startLabel = start.label
        self.endLabel = end.label
    }

    /// Creates an empty `Duration` instance.
    ///
    /// Creates an `Duration` with `duration` set to 0 and labels as empty strings.
    /// Useful for placeholder values or default initialization.
    public init() {
        duration = 0
        startLabel = ""
        endLabel = ""
    }
}
