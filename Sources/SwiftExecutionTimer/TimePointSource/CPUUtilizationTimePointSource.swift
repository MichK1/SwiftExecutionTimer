//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation

final class CPUUtilizationTimePointSource: TimePointSource  {
    var timePointNow: Double {
        var usage = rusage()
#if os(Linux)
        getrusage(RUSAGE_SELF.rawValue, &usage)
#else
        getrusage(RUSAGE_SELF, &usage)
#endif
        return Double(usage.ru_utime.tv_sec) + Double(usage.ru_utime.tv_usec) / 1_000_000
    }
}
