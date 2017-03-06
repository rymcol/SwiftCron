//
//  main.swift
//  Swift-Cron
//
//  Created by Ryan Collins on 2/22/17.
//
//

import Foundation

var shouldKeepRunning = true        // change this `false` to stop the application from running
let theRL = RunLoop.current         // Need a reference to the current run loop

// Welcome to Cron!
// If you add frequency: X to the intializer here, cron will attempt to run your jobs every X seconds
// If you do not add a frequency, it defaults to 60 (every minute)
let cronStorage = MemoryCronStore()
let cron = Cron(frequency: 3, cronStorage: cronStorage)


//Define Functions
func test() {
    print("🚀")
}

func test2() {
    print("😻")
}

//Add functions as cron jobs
cron.add(CronJob(test, executeAfter: Date(), repeats: true))
cron.add(CronJob(test2, executeAfter: Date()))

//Start Cron
cron.start()

//Start and Keep Running the Run Loop
while shouldKeepRunning && theRL.run(mode: .defaultRunLoopMode, before: .distantFuture) {  }
