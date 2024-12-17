//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation

/// `ExecutionTimer` is responsible for measuring execution times in a Swift application. ExecutionTimer is not thread safe.
///
/// Example:
/// ```swift
/// let timer = ExecutionTimer()
/// timer.measure("Start Task", "End Task") {
///     // Task to measure
/// }
/// print(timer.durations)
/// ```
public class ExecutionTimer {
    /// `TimeSource` defines which source of time to use
    public enum TimeSource {
        /// Measure time using a monotonic clock (e.g., system uptime since boot)
        case monotonic
        /// Measure time using user-level processor time (CPU usage)
        case cpuUtilizationTime
    }

    /// `TimePoint`s added at specific execution points of the application.
    public private(set) var relativeTimePoints: [TimePoint] = []
    /// The initial `TimePoint` added to the measurement.
    public private(set) var initialTimePoint: Double = Double.nan
    
    /// Durations of the periods between time points.
    public var durations: [Duration] {
        zip(relativeTimePoints, relativeTimePoints.dropFirst()).map { Duration(start: $0, end: $1) }
    }

    /// The chosen `TimeSource`.
    public let timeSource: TimeSource
    private let timePointSource: TimePointSource
    
    /// Initializes an `ExecutionTimer` instance with the given measurement method.
    ///
    /// - Parameters:
    ///   - timeSource: Defines which measurement method to use. Defaults to `.monotonic`.
    public convenience init(timeSource: TimeSource = .monotonic) {
        self.init(dependencies: ExecutionTimerDependenciesImpl(), timeSource: timeSource)
    }

    init(dependencies: ExecutionTimerDependencies, timeSource: TimeSource = .monotonic) {
        self.timeSource = timeSource
        switch timeSource {
        case .monotonic:
            self.timePointSource = dependencies.monotonicTimePointSource
        case .cpuUtilizationTime:
            self.timePointSource = dependencies.cpuUtilizationTimePointSource
        }
    }

    /// Adds a mark at the current time point, described by a label.
    ///
    /// - Parameters:
    ///   - label: Additional information describing the time point.
    public func mark(_ label: String = "") {
        let timePoint = timePointSource.timePointNow
        if initialTimePoint.isNaN {
            initialTimePoint = timePoint
        }
        relativeTimePoints.append(TimePoint(timePoint: timePoint - initialTimePoint, label: label))
    }

    /// Measures the time taken for a specified action.
    ///
    /// Adds two `TimePoint`s: one at the start and one at the end of the action execution.
    /// Optionally marks the start and end points with labels.
    ///
    /// - Parameters:
    ///   - startLabel: Additional information describing the starting point.
    ///   - endLabel: Additional information describing the ending point.
    ///   - action: The action to measure.
    public func measure(_ startLabel: String = "", _ endLabel: String = "", _ action: VoidClosure) {
        mark(startLabel)
        action()
        mark(endLabel)
    }

    /// Measures the time taken for a specified action, handling errors.
    ///
    /// Adds two `TimePoint`s: one at the start and one at the end of the action execution.
    /// Optionally marks the start and end points with labels.
    ///
    /// - Parameters:
    ///   - startLabel: Additional information describing the starting point.
    ///   - endLabel: Additional information describing the ending point.
    ///   - action: The action to measure.
    ///
    /// - Throws: Rethrows any errors thrown by the action.
    public func measure(_ startLabel: String = "", _ endLabel: String = "", _ action: VoidThrowingClosure) throws {
        defer {
            mark(endLabel)
        }
        mark(startLabel)
        try action()
    }
        
    /// Returns the sum of all durations that match the given filter.
    ///
    /// - Parameter filter: The filter used to match specific durations.
    /// - Returns: The total duration of all matching periods.
    public func sumDurations(filter: DurationFilter) -> Double {
        return durations.reduce(0) { sum, duration in
            sum + (filter.matches(duration) ? duration.duration : 0)
        }
    }
    
    /// Returns an array of durations that match the given filter.
    ///
    /// - Parameter filter: The filter used to match specific durations.
    /// - Returns: An array of `Duration` values that satisfy the filter criteria.
    public func durations(filter: DurationFilter) -> [Duration] {
        return durations.filter { filter.matches($0) }
    }

}
