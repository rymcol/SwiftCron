//
//  Cron.swift
//  Swift-Cron
//
//  Created by Ryan Collins on 2/22/17.
//
//

import Foundation

//Base Cron
public class Cron {
    private var _cronStore: CronStore
    private var _timer: Timer!
    private var _interval: TimeInterval
    
    /// Cron Initialization
    ///
    /// - Parameters:
    ///   - frequency: how often to check for and run cron jobs that have passed their run Date, in seconds
    ///   - cronStorage: Where to store cron jobs (default is in memory, but you can use a pre-made database connector or your own implementation here)
    public init(frequency: TimeInterval = 60, cronStorage: CronStore = MemoryCronStore()) {
        _cronStore = cronStorage
        _interval = frequency
    }
    
    public func start() {
        _timer = Timer.scheduledTimer(timeInterval: _interval, target: self, selector: #selector(run), userInfo: nil, repeats: true)
        RunLoop.current.add(_timer, forMode: .commonModes)
    }
    
    @objc func run() {
        for job in _cronStore.jobs {
            if job.date <= Date() {
                job.method()
                
                _cronStore.remove(job)
                
                if job.repeats {
                    if let interval = job.repeatInterval {
                        job.set(date: Date(timeInterval: interval, since: job.date))
                    }
                    
                    cronStorage.add(job)
                }
                
            }
        }
    }
    
    public func stop() {
        _timer.invalidate()
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
