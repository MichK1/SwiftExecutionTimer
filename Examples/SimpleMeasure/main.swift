//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation
import SwiftExecutionTimer

func runAndMeasure() {
    let executionTimer = ExecutionTimer() // Initialize the timer with the default `.monotonic` source
    
    (0..<100).forEach { trialIndex in
        executionTimer.mark("ARRAY INIT")      // Mark the beginning of array initialization.
        var array = (0..<1000).map { _ in Double.random(in: 0...1) }
        
        executionTimer.mark("SORT BEGIN")      // Mark the beginning of array sorting.
        array.sort()                           // Sort the array
        executionTimer.mark("SORT END")        // Mark the end of array sorting.
    }
    
    // Calculate durations for time intervals starting at "SORT BEGIN".
    let durations = executionTimer.durations(filter: .startLabel(.exact("SORT BEGIN"))) // Filter by exact match for "SORT BEGIN".
    let minTime = durations.min(by: { $0.duration < $1.duration })?.duration
    let maxTime = durations.max(by: { $0.duration < $1.duration })?.duration
    let sortingTime = executionTimer.sumDurations(filter: .startLabel(.exact("SORT BEGIN")))
    
    // Print results
    print("Sorting 100 arrays with 1000 Doubles took: \(sortingTime) seconds")
    print("Minimum sorting time: \(minTime ?? 0) seconds")
    print("Maximum sorting time: \(maxTime ?? 0) seconds")
}

runAndMeasure()
