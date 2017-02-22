//
//  Cron.swift
//  Swift-Cron
//
//  Created by Ryan Collins on 2/22/17.
//
//

import Foundation

public class Cron {
    
    private var _jobs: [CronJob]
    private var _timer: Timer
    
    public var jobs: [CronJob] {
        get {
            return _jobs
        }
    }
    
    public init(start: TimeInterval = 60) {
        _jobs = [CronJob]()
        _timer = Timer(timeInterval: start, target: TimerTarget(), selector: #selector(run), userInfo: nil, repeats: true)
    }
    
    @objc private func run() {
        for job in _jobs {
            job.method()
        }
    }
    
}

private class TimerTarget {
    init() {  }
}
