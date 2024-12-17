//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation

/// A filter used to determine whether a `Duration` meets specific matching criteria.
///
/// `DurationFilter` applies conditions to either the start or end labels of a `Duration`
/// using various matching strategies, such as prefix, suffix, or regular expressions.
public struct DurationFilter {
    
    /// Defines the conditions used to match a `Duration` label.
    public enum MatchingCondition: Equatable {
        /// Matches labels that start with the specified prefix.
        /// - Parameter prefix: The string to match as the label's starting value.
        case prefix(String)
        
        /// Matches labels that end with the specified suffix.
        /// - Parameter suffix: The string to match as the label's ending value.
        case suffix(String)
        
        /// Matches labels using the given regular expression.
        /// - Parameter regex: The `NSRegularExpression` to evaluate against the label.
        case regex(NSRegularExpression)
    }

    /// Specifies which `Duration` label should be evaluated by the filter.
    ///
    /// Labels include:
    /// - `start`: Matches the start label of the duration.
    /// - `end`: Matches the end label of the duration.
    public enum Label {
        /// Matches the start label of the duration.
        case start
        /// Matches the end label of the duration.
        case end
    }
    
    /// Matching conditions used to evaluate a `Duration` label.
    public let matchingCondition: MatchingCondition
    /// Defines which `Duration` label should be evaluated by the filter.
    public let labelToMatch: Label
    
    /// Creates a `DurationFilter` to match the start label of a `Duration`.
    ///
    /// - Parameter condition: The matching condition to apply to the start label.
    /// - Returns: A `DurationFilter` configured to evaluate start labels.
    public static func startLabel(_ condition: MatchingCondition) -> DurationFilter {
        DurationFilter(matchingCondition: condition, labelToMatch: .start)
    }

    /// Creates a `DurationFilter` to match the end label of a `Duration`.
    ///
    /// - Parameter condition: The matching condition to apply to the end label.
    /// - Returns: A `DurationFilter` configured to evaluate end labels.
    public static func endLabel(_ condition: MatchingCondition) -> DurationFilter {
        DurationFilter(matchingCondition: condition, labelToMatch: .end)
    }

    /// Initializes a `DurationFilter` with a specified matching condition and label to evaluate.
    ///
    /// - Parameters:
    ///   - matchingCondition: The condition to use for matching labels.
    ///   - labelToMatch: Specifies whether to evaluate the start or end label.
    public init(matchingCondition: MatchingCondition, labelToMatch: Label) {
        self.matchingCondition = matchingCondition
        self.labelToMatch = labelToMatch
    }

    /// Evaluates whether the given `Duration` matches the filter criteria.
    ///
    /// - Parameter duration: The `Duration` to evaluate.
    /// - Returns: `true` if the `Duration` satisfies the filter conditions; otherwise, `false`.
    public func matches(_ duration: Duration) -> Bool {
        let label: String
        switch labelToMatch {
        case .start:
            label = duration.startLabel
        case .end:
            label = duration.endLabel
        }
        
        switch matchingCondition {
        case let .prefix(prefix):
            return label.hasPrefix(prefix)
        case let .suffix(suffix):
            return label.hasSuffix(suffix)
        case let .regex(regex):
            return regex.numberOfMatches(in: label, range: NSRange(location: 0, length: label.utf16.count)) > 0
        }
    }

}
