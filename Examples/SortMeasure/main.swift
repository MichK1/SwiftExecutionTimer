//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import SwiftExecutionTimer

typealias Closure = (_ array: inout [Double]) -> Void

let arrayCount = 2000
let trialsCount = 100

func main() {
    let sortMeasure = SortMeasure(timeSource: .cpuUtilizationTime, arrayCount: arrayCount, trialsCount: trialsCount)
    print("Sorting array of random Doubles of length \(arrayCount); Trials count: \(trialsCount)")
    sortMeasure.measure()
    print("Measurements runing time: \(sortMeasure.totalDuration)")
    print(" Arrays generation time: \(sortMeasure.arrayGenerationsTotalDuration)")
    for result in sortMeasure.durations {
        print(" \(result.0.label); \(result.0.description); runinng time: \(result.1)")
    }
}

main()
