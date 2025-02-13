//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation

final class MonotonicTimePointSource: TimePointSource {
    var timePointNow: Double {
#if os(Linux)
        var ts = timespec()
        clock_gettime(CLOCK_MONOTONIC, &ts)
        return Double(ts.tv_sec) + Double(ts.tv_nsec) / 1_000_000_000
#else
        return Double(DispatchTime.now().uptimeNanoseconds) / 1_000_000_000
#endif
    }
}
