//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation
import Testing
@testable import SwiftExecutionTimer

@Suite
struct DurationFilterTests {
    @Test func checkInitialisationForStartLabel() {
        let sut = DurationFilter.startLabel(.prefix("Foo"))
        #expect(sut.matchingCondition == .prefix("Foo"))
        #expect(sut.labelToMatch == .start)
    }

    @Test func checkInitialisationForEndLabel() {
        let sut = DurationFilter.endLabel(.suffix("Bar"))
        #expect(sut.matchingCondition == .suffix("Bar"))
        #expect(sut.labelToMatch == .end)
    }

    @Test func checkDurationMatchingSuffix() {
        let duration = Duration(duration: 2, startLabel: "Foo", endLabel: "AbcBar")
        let sut = DurationFilter.endLabel(.suffix("Bar"))
        #expect(sut.matches(duration))
    }

    @Test func checkDurationNotMatchingSuffix() {
        let duration = Duration(duration: 2, startLabel: "Foo", endLabel: "BarAbc")
        let sut = DurationFilter.endLabel(.suffix("Bar"))
        #expect(!sut.matches(duration))
    }

    @Test func checkDurationMatchingPrefix() {
        let duration = Duration(duration: 2, startLabel: "Foo", endLabel: "AbcBar")
        let sut = DurationFilter.startLabel(.prefix("Fo"))
        #expect(sut.matches(duration))
    }

    @Test func checkDurationNotMatchingPrefix() {
        let duration = Duration(duration: 2, startLabel: "Foo", endLabel: "BarAbc")
        let sut = DurationFilter.startLabel(.prefix("oo"))
        #expect(!sut.matches(duration))
    }

    @Test func checkDurationMatchingRegex() {
        let regex = try! NSRegularExpression(pattern: "[0-9]+")
        let duration = Duration(duration: 2, startLabel: "Foo0123hjk", endLabel: "BarAbc")
        let sut = DurationFilter.startLabel(.regex(regex))
        #expect(sut.matches(duration))
    }

    @Test func checkDurationNotMatchingRegex() {
        let regex = try! NSRegularExpression(pattern: "[7-9]+")
        let duration = Duration(duration: 2, startLabel: "Foo123", endLabel: "BarAbc")
        let sut = DurationFilter.startLabel(.regex(regex))
        #expect(!sut.matches(duration))
    }

    @Test func checkDurationMatchingExact() {
        let duration = Duration(duration: 2, startLabel: "Foo Bar", endLabel: "BarAbc")
        let sut = DurationFilter.startLabel(.exact("Foo Bar"))
        #expect(sut.matches(duration))
    }

    @Test func checkDurationNotMatchingExact() {
        let duration = Duration(duration: 2, startLabel: "Foo Bar", endLabel: "BarAbc")
        let sut = DurationFilter.startLabel(.exact("Foo Ba"))
        #expect(!sut.matches(duration))
    }

}
