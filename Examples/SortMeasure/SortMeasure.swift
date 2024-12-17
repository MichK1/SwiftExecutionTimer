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

typealias SortAction = @Sendable (_ array: inout [Double]) -> Void

struct SortActionEntry: Sendable {
    let label: String
    let action: SortAction
    let description: String
}

let entries = [
    SortActionEntry(
        label: "selection sort 1",
        action: selectionSortVariantOne,
        description: "Using Array.count in loop condition"
    ),
    SortActionEntry(
        label: "selection sort 2",
        action: selectionSortVariantTwo,
        description: "Using n in loop condition, where let n = Array.count"
    ),
    SortActionEntry(
        label: "system sort",
        action: systemSort,
        description: "System sort"
    ),
]

class SortMeasure {
    private let executionTimer: ExecutionTimer
    
    let arrayCount: Int
    let trialsCount: Int
    
    var arrayGenerationsTotalDuration: Double {
        return executionTimer.sumDurations(filter: .startLabel(.suffix("array generation start")))
    }

    var durations: [(SortActionEntry, Double)] {
        entries.map { entry in
            let regex = try! NSRegularExpression(pattern: "^\(entry.label).*sort execution$")
            let durationSum = executionTimer.sumDurations(filter: .startLabel(.regex(regex)))
            return (entry, durationSum)
        }
    }

    var totalDuration: Double {
        executionTimer.relativeTimePoints.last?.timePoint ?? 0
    }
    
    init(timeSource: ExecutionTimer.TimeSource, arrayCount: Int, trialsCount: Int) {
        executionTimer = ExecutionTimer(timeSource: timeSource)
        self.arrayCount = arrayCount
        self.trialsCount = trialsCount
    }
    
    func measure() {
        executionTimer.mark("measure start")
        entries.forEach { entry in
            runTrials(entry)
        }
        executionTimer.mark("measure end")
    }
    
    private func runTrials(_ entry: SortActionEntry) {
        var trial = 0
        while trial < trialsCount {
            executionTimer.mark("\(entry.label) trial: \(trial) array generation start")
            var array = (0..<arrayCount).map { _ in Double.random(in: 0...1) }
            executionTimer.mark("\(entry.label) trial: \(trial) array generation end")
            executionTimer.measure("\(entry.label) trial: \(trial) sort execution") {
                entry.action(&array)
            }
            assert(isSorted(array), "\(entry.label) trial \(trial) array not sorted")
            trial += 1
        }
        
    }

}
