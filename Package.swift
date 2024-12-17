// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "SwiftExecutionTimer",
    products: [
        .library(
            name: "SwiftExecutionTimer",
            targets: ["SwiftExecutionTimer"]),
    ],
    targets: [
        .target(
            name: "SwiftExecutionTimer"),
        .testTarget(
            name: "SwiftExecutionTimerTests",
            dependencies: ["SwiftExecutionTimer"]
        ),
        //Example
        .executableTarget(
            name: "SortMeasure",
            dependencies: ["SwiftExecutionTimer"],
            path: "Examples/SortMeasure"
        ),

    ]
)
