//
// This file is part of SwiftExecutionTimer.
//
// Created in 2025 by Michał Kłoczko.
//
// Licensed under the MIT License.
// See the LICENSE.txt file in the project root for full license information.
//

import Foundation
import SwiftExecutionTimer

struct Poke: Codable {
    let baseExperience: Int
    let height: Int
    let id: Int
    let isDefault: Bool
    let name: String
    let order: Int
    let weight: Int
}

let executionTimer = ExecutionTimer()
executionTimer.mark("application start")

func present(_ poke: Poke?, label: String) {
    executionTimer.mark("present \(label)")
    if let poke {
        print("Poke \(label) name: \(poke.name), weight: \(poke.weight)")
    } else {
        print("Poke \(label) not found")
    }
}

func downloadAndPresent(poke: String) {
    DispatchQueue.global().async {
        executionTimer.mark("download \(poke) start")
        do {
            let data = try Data(contentsOf: URL(string: "https://pokeapi.co/api/v2/pokemon/\(poke)")!)
            executionTimer.mark("parse \(poke) start")
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(Poke.self, from: data)
            executionTimer.mark("parse \(poke) end")
            DispatchQueue.main.async {
                present(result, label: poke)
            }
        } catch {
            executionTimer.mark("execution error for \(poke), error: \(error)")
        }
        
    }
}


signal(SIGINT) { _ in
    print("\nCaught SIGINT. Exiting...")
    executionTimer.mark("application end")
    print("Application run \(String(describing: executionTimer.relativeTimePoints.last?.timePoint)) seconds")
    print("Application time points: ")
    executionTimer.relativeTimePoints.forEach {
        print(" \($0)")
    }
    exit(0)
}

downloadAndPresent(poke: "ditto")
downloadAndPresent(poke: "foobar")
executionTimer.mark("in the middle")
downloadAndPresent(poke: "pikachu")

print("Running. Press Ctr+C to stop.")
RunLoop.main.run()

//
