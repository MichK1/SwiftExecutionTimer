//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation

protocol ExecutionTimerDependencies {
    func timePointSource(_ source: ExecutionTimer.TimeSource) -> TimePointSource
}

class ExecutionTimerDependenciesImpl: ExecutionTimerDependencies {
    func timePointSource(_ timeSource: ExecutionTimer.TimeSource) -> TimePointSource {
        switch timeSource {
        case .monotonic:
            MonotonicTimePointSource()
        case .cpuUtilizationTime:
            CPUUtilizationTimePointSource()
        }
    }
}
