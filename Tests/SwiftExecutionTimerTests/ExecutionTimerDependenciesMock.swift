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
    
    var timePointSourceStub = TimePointReaderStub()

    func timePointSource(_ source: SwiftExecutionTimer.ExecutionTimer.TimeSource) -> any SwiftExecutionTimer.TimePointSource {
        timePointSourceStub.source = source
        return timePointSourceStub
    }

}

class TimePointReaderStub: TimePointSource, @unchecked Sendable {
    var timePointNow: Double {
        set {
            timePoints = [newValue]
            timePointsCurrentIndex = 0
        }
        get {
            guard timePointsCurrentIndex < timePoints.count else { return -1 }
            let index = timePointsCurrentIndex
            timePointsCurrentIndex += 1
            return timePoints[index]
        }
    }
    
    var source = SwiftExecutionTimer.ExecutionTimer.TimeSource.monotonic
    
    var timePoints: [Double] = []
    var timePointsCurrentIndex = 0
}
