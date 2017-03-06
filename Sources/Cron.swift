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
                
                if !job.repeats {
                    _cronStore.remove(job)
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
    
    public func remove(_ job: CronJob) {
        self._cronStore.remove(job)
    }
}

//Storage Protocol
public protocol CronStore {
    var jobs: [CronJob] { get }
    
    func add(_ job: CronJob)
    func remove(_ job: CronJob)
}

//Default implementation of cron storage in memory
public class MemoryCronStore: CronStore {
    
    private var _jobs: [CronJob]
    
    public var jobs: [CronJob] {
        get {
            return _jobs
        }
    }
    
    public init() {
        _jobs = [CronJob]()
    }
    
    public func add(_ job: CronJob) {
        _jobs.append(job)
    }
    
    public func remove(_ job: CronJob) {
        _jobs = _jobs.filter() { $0 != job }
    }
    
}
