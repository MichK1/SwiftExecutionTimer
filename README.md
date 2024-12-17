# SwiftExecutionTimer

The SwiftExecutionTimer package allows you to measure the execution times of specific code segments. 

## Installation

SwiftExecutionTimer can be installed using Swift Package Manager:

```
dependencies: [
        .package(url: "https://github.com/MichK1/SwiftExecutionTimer.git", exact: "0.1.0"),
    ]
```

## Usage

The ExecutionTimer class helps measure execution times by adding marks at various points during code execution.
Each mark can optionally include a label for clarity. To add a mark, call the ExecutionTimer.mark() method.

### Features:

- **Time Points**: Marks are stored as an array of `TimePoint` objects, recorded relative to the first mark (set to `0`).
- **Durations**: The time spans between consecutive marks are represented by the `Duration` structure, which includes:
  - `duration`: The elapsed time.
  - `startLabel` and `endLabel`: Labels from the corresponding time points.

### Time Sources

`ExecutionTimer` supports two time sources:
 - `.monotonic`: Based on system uptime in seconds.
 - `.cpuUtilizationTime`: Based on CPU time spent executing the current process (user mode only). More details can be found [here][getrusage].
    
### Example: Measuring Sorting Time

The example below measures the time taken to sort an array of 1000 random `Double` values, repeated 100 times:

```swift
import SwiftExecutionTimer

func runAndMeasure() {
    let executionTimer = ExecutionTimer() // Initialize the timer with the default `.monotonic` source
    
    (0..<100).forEach { trialIndex in
        executionTimer.mark("ARRAY INIT")      // Mark array initialization start
        var array = (0..<1000).map { _ in Double.random(in: 0...1) }
        
        executionTimer.mark("SORT BEGIN")      // Mark sorting start
        array.sort()                           // Sort the array
        executionTimer.mark("SORT END")        // Mark sorting end
    }
    
    // Calculate durations for marks starting with "SORT BEGIN"
    let durations = executionTimer.durations(filter: .startLabel(.prefix("SORT BEGIN")))
    let minTime = durations.min()
    let maxTime = durations.max()
    let sortingTime = executionTimer.sumDurations(filter: .startLabel(.prefix("SORT BEGIN")))
    
    // Print results
    print("Sorting 100 arrays with 1000 Doubles took: \(sortingTime) seconds")
    print("Minimum sorting time: \(minTime ?? 0) seconds")
    print("Maximum sorting time: \(maxTime ?? 0) seconds")
}
```

## Further examples

Additional example, sorting execution time comparisons, can be found in the SortMeasure example.

## License

SwiftExecutionTimer is available under the MIT license. See the [LICENSE][License] file for more informations.

[License]: https://github.com/MichK1/SwiftExecutionTimer/blob/main/LICENSE.txt
[getrusage]: https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man2/getrusage.2.html
