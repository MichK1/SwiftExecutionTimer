//
//  ExecutionTimerConcurrencyTests.swift
//  SwiftExecutionTimer
//
//  Created by Michał on 18/03/2025.
//

import Foundation
import Testing
@testable import SwiftExecutionTimer

@Suite
struct ExecutionTimerConcurrencyTests {

    @Test
    func mark_canBeUsedFromMultipleTasks() async {
        let timer = ExecutionTimer()

        await withTaskGroup(of: Void.self) { group in
            for i in 0..<1000 {
                group.addTask {
                    timer.mark("Task \(i)")
                }
            }
        }

        #expect(timer.relativeTimePoints.count == 1000)
    }

    @Test
    func measure_canBeUsedConcurrently() async {
        let timer = ExecutionTimer()

        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<200 {
                group.addTask {
                    timer.measure("start", "end") {
                        // simulate work
                        Thread.sleep(forTimeInterval: 0.0001)
                    }
                }
            }
        }

        // 200 measure calls → 200 durations
        #expect(timer.relativeTimePoints.count == 400)
    }

    @Test
    func properties_canBeAccessedWhileMarking() async {
        let timer = ExecutionTimer()

        await withTaskGroup(of: Void.self) { group in
            for i in 0..<500 {
                group.addTask {
                    timer.mark("Mark \(i)")
                    _ = timer.durations
                    _ = timer.initialTimePoint
                }
            }
        }

        #expect(timer.relativeTimePoints.count == 500)
    }
}
