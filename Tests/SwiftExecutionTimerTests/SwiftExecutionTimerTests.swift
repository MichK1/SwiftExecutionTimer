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

@Suite
struct ExecutionTimerTests {
    let dependenciesMock = ExecutionTimerDependenciesMock()
    
    @Test func checkInitialisation() {
        #expect(executionTimer(.monotonic).timeSource == .monotonic)
        #expect(executionTimer(.cpuUtilizationTime).timeSource == .cpuUtilizationTime)
    }

    @Test func checkEmptyMeasurement() {
        let executionTimer = executionTimer(.monotonic)
        #expect(executionTimer.relativeTimePoints == [])
        #expect(executionTimer.durations == [])
    }

    
    @Test func checkAddingOneTimePoint() {
        let executionTimer = executionTimer(.monotonic)
        dependenciesMock.timePointSourceStub.timePointNow =  3
        let expected = [TimePoint(timePoint: 0, label: "")]
        executionTimer.mark()
        #expect(executionTimer.initialTimePoint == 3)
        #expect(executionTimer.relativeTimePoints == expected)
        #expect(executionTimer.durations == [])
    }

    @Test func checkAddingTwoTimePoints() {
        let expectedTimePoints = [TimePoint(timePoint: 0, label: ""), TimePoint(timePoint: 3, label: "")]
        let expectedDurations = [Duration(duration: 3, startLabel: "", endLabel: "")]
        let executionTimer = executionTimer(.monotonic)
        dependenciesMock.timePointSourceStub.timePoints =  [3, 6]
        executionTimer.mark()
        executionTimer.mark()
        
        #expect(executionTimer.initialTimePoint == 3)
        #expect(executionTimer.relativeTimePoints == expectedTimePoints)
        #expect(executionTimer.durations == expectedDurations)
    }

    @Test func checkAddingThreeTimePoints() {
        let expectedTimePoints = [
            TimePoint(timePoint: 0, label: "First"),
            TimePoint(timePoint: 3, label: "Second"),
            TimePoint(timePoint: 7, label: ""),
        ]
        let expectedDurations = [
            Duration(duration: 3, startLabel: "First", endLabel: "Second"),
            Duration(duration: 4, startLabel: "Second", endLabel: "")
        ]
        let executionTimer = executionTimer(.monotonic)
        dependenciesMock.timePointSourceStub.timePoints =  [3, 6, 10]
        executionTimer.mark("First")
        executionTimer.mark("Second")
        executionTimer.mark()
        #expect(executionTimer.initialTimePoint == 3)
        #expect(executionTimer.relativeTimePoints == expectedTimePoints)
        #expect(executionTimer.durations == expectedDurations)
    }

    @Test func checkDurationsSumForEndLabelHavingSuffix() {
        let executionTimer = executionTimer(.monotonic)
        dependenciesMock.timePointSourceStub.timePoints =  [3, 6, 10, 13]
        executionTimer.mark("First")
        executionTimer.mark("Second")
        executionTimer.mark()
        executionTimer.mark("Second")
        #expect(executionTimer.sumDurations(filter: .endLabel(.suffix("cond"))) == 6)
    }

    @Test func checkDurationsSumIsZeroForEndLabelSuffixNotPresent() {
        let executionTimer = executionTimer(.monotonic)
        dependenciesMock.timePointSourceStub.timePoints =  [3, 6, 10, 13]
        executionTimer.mark("First")
        executionTimer.mark("Second")
        executionTimer.mark()
        executionTimer.mark("Second")
        #expect(executionTimer.sumDurations(filter: .endLabel(.suffix("foo"))) == 0)
    }

    private func executionTimer(_ timeSource: ExecutionTimer.TimeSource) -> ExecutionTimer {
        ExecutionTimer(dependencies: dependenciesMock, timeSource: timeSource)
    }
}
