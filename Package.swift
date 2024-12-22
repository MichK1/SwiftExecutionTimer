// swift-tools-version: 5.8

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
        //Examples
        .executableTarget(
            name: "SortMeasure",
            dependencies: ["SwiftExecutionTimer"],
            path: "Examples/SortMeasure"
        ),
        .executableTarget(
            name: "SimpleMeasure",
            dependencies: ["SwiftExecutionTimer"],
            path: "Examples/SimpleMeasure"
        ),
    ]
)
