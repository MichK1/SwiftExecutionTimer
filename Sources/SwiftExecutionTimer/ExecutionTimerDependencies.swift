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
    var monotonicTimePointSource: TimePointSource { get }
    var cpuUtilizationTimePointSource: TimePointSource { get }
}

class ExecutionTimerDependenciesImpl: ExecutionTimerDependencies {
    var monotonicTimePointSource: TimePointSource { MonotonicTimePointSource() }
    
    var cpuUtilizationTimePointSource: TimePointSource { CPUUtilizationTimePointSource() }
}
