//
//  Cron.swift
//  Swift-Cron
//
//  Created by Ryan Collins on 2/22/17.
//
//

import Foundation
import PerfectThread
#if os(Linux)
    import SwiftGlibc
#else
    import Darwin
#endif

public class Cron {
    private var _cronStore: CronStore
    private var _runningJobs: [CronJob]
    private var _interval: UInt32
    private var _run: Bool
    private let queue = DispatchQueue(label: "SerialQueueCorn")
    
    /// Cron Initialization
    ///
    /// - Parameters:
    ///   - frequency: how often to check for and run cron jobs that have passed their run Date, in seconds
    ///   - cronStorage: Where to store cron jobs (default is in memory, but you can use a pre-made database connector or your own implementation here)
    public init(frequency: UInt32 = 60, cronStorage: CronStore = MemoryCronStore()) {
        _cronStore = cronStorage
        _interval = frequency
        _runningJobs = [CronJob]()
        _run = true
    }
    
    public func start() {
        while self._run {
            sleep(self._interval)
            run()
        }
    }
    
    func run() {
        queue.async {
            for job in self._cronStore.jobs {
                if job.allowsSimultaneious || (!job.allowsSimultaneious && !self._runningJobs.contains(job)) {
                    if job.date <= Date() {
                        
                        let _ = Promise() {
                            self._runningJobs.append(job)
                            job.method()
                            }.then() {_ in
                                self._runningJobs = self._runningJobs.filter() { $0 != job }
                        }
                        
                        self._cronStore.remove(job)
                        
                        if job.repeats {
                            if let interval = job.repeatInterval {
                                job.set(date: Date(timeInterval: interval, since: job.date))
                            }
                            
                            self._cronStore.add(job)
                        }
                        
                    }
                }
            }
        }
    }
    
    public func stop() {
        _run = false
    }
    
    public func add(_ job: CronJob) {
        self._cronStore.add(job)
    }
    
    public func add(_ jobs: [CronJob]) {
        for job in jobs {
            add(job)
        }
    }
    
    public func remove(_ job: CronJob) {
        self._cronStore.remove(job)
    }
}
