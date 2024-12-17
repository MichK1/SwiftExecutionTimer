//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Testing
@testable import SwiftExecutionTimer

class ExecutionTimerDependenciesMock: ExecutionTimerDependencies {
    var monotonicTimePointSourceStub = TimePointReaderStub()
    var cpuUtilizationTimePointSourceStub = TimePointReaderStub()

    var monotonicTimePointSource: TimePointSource {
        monotonicTimePointSourceStub
    }
    
    var cpuUtilizationTimePointSource: TimePointSource {
        cpuUtilizationTimePointSourceStub
    }

}

class TimePointReaderStub: TimePointSource {
    var timePointNow: Double = -1
}
