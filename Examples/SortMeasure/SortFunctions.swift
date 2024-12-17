//
// This file is part of SwiftExecutionTimer.
//
// Created in 2024 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

func selectionSortVariantOne(_ a: inout [Double]) {
    var i = 0
    while i < a.count {
        var min = i
        var j = i + 1
        while j < a.count {
            if a[j] < a[min] { min = j }
            j += 1
        }
        a.swapAt(i, min)
        i += 1
    }
}

func selectionSortVariantTwo(_ a: inout [Double]) {
    var i = 0
    let n = a.count
    while i < n {
        var min = i
        var j = i + 1
        while j < n {
            if a[j] < a[min] { min = j }
            j += 1
        }
        a.swapAt(min, i)
        i += 1
    }
}

func systemSort(_ a: inout [Double]) {
    a.sort()
}


func isSorted(_ array: [Double]) -> Bool {
    for (l, r) in zip(array, array.dropFirst()) {
        if r < l { return false }
    }
    return true
}
