# SwiftExecutionTimer

A lightweight Swift library that allows you to measure code execution time using labeled intervals. 

## Installation

SwiftExecutionTimer can be installed using Swift Package Manager:

```
dependencies: [
        .package(url: "https://github.com/MichK1/SwiftExecutionTimer.git", from: "0.2.0"),
    ]
```

## Usage

The ExecutionTimer class helps measure execution times by adding marks at various points during code execution.
Each mark can optionally include a label for clarity. You can add a mark by calling the method ExecutionTimer.mark(), optionally providing a label.

### Features:

- **Time Points**: Marks are stored as an array of `TimePoint` objects, recorded relative to the first mark (set to `0`).
- **Durations**: The time spans between consecutive marks are represented by the `Duration` structure, which includes:
  - `duration`: The elapsed time.
  - `startLabel` and `endLabel`: Labels from the corresponding time points.

### Time Sources

`ExecutionTimer` supports two time sources:
 - `.monotonic`: Based on system uptime in seconds.
 - `.cpuUtilizationTime`: Based on CPU time spent executing the current process (user mode only). More details are available [here][getrusage].
    
### Example: Measuring Sorting Time

The example below measures the time taken to sort an array of 1000 random `Double` values, repeated 100 times:

```swift
import SwiftExecutionTimer

func runAndMeasure() {
    let executionTimer = ExecutionTimer() // Initialize the timer with the default `.monotonic` source
    
    (0..<100).forEach { trialIndex in
        executionTimer.mark("ARRAY INIT")      // Mark the beginning of array initialization.
        var array = (0..<1000).map { _ in Double.random(in: 0...1) }
        
        executionTimer.mark("SORT BEGIN")      // Mark the beginning of array sorting.
        array.sort()                           // Sort the array
        executionTimer.mark("SORT END")        // Mark the end of array sorting.
    }
    
    // Calculate durations for time intervals starting at "SORT BEGIN".
    let durations = executionTimer.durations(filter: .startLabel(.exact("SORT BEGIN")))
    let minTime = durations.min(by: { $0.duration < $1.duration })?.duration
    let maxTime = durations.max(by: { $0.duration < $1.duration })?.duration
    let sortingTime = executionTimer.sumDurations(filter: .startLabel(.exact("SORT BEGIN")))
    
    // Print results
    print("Sorting 100 arrays with 1000 Doubles took: \(sortingTime) seconds")
    print("Minimum sorting time: \(minTime ?? 0) seconds")
    print("Maximum sorting time: \(maxTime ?? 0) seconds")
}
```

## Further examples

You can find more examples in the *Examples* folder. You can see them in action by running swift products:
 - SimpleDownload
 - SimpleMeasure
 - SortMeasure

```zsh
% swift run SimpleDownload
% swift run SimpleMeasure
% swift run SortMeasure
```

## License

SwiftExecutionTimer is available under the MIT license. See the [LICENSE][License] file for more information.

[License]: https://github.com/MichK1/SwiftExecutionTimer/blob/main/LICENSE.txt
[getrusage]: https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/getrusage.2.html
