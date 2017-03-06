//
//  Cron.swift
//  Swift-Cron
//
//  Created by Ryan Collins on 2/22/17.
//
//

import Foundation

public class Cron {
    
    private var _interval: TimeInterval
    private var _jobs: [CronJob]
    private var _timer: Timer!
    
    public var jobs: [CronJob] {
        get {
            return _jobs
        }
    }
    
    public init(frequency: TimeInterval = 60) {
        _jobs = [CronJob]()
        _interval = frequency
    }
    
    public func start() {
        _timer = Timer.scheduledTimer(timeInterval: _interval, target: self, selector: #selector(run), userInfo: nil, repeats: true)
        RunLoop.current.add(_timer, forMode: .commonModes)
    }
    
    @objc func run() {
        for job in _jobs {
            
            if job.date <= Date() {
                job.method()
                
                if !job.repeats {
                    self.remove(job)
                }
            }
        }
    }
    
    func add(_ job: CronJob) {
        _jobs.append(job)
    }
    
    func remove(_ job: CronJob) {
        _jobs = _jobs.filter() { $0 != job }
    }
    
}
