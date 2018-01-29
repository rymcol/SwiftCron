//
//  CronStorage.swift
//  Swift-Cron
//
//  Created by Ryan Collins on 3/6/17.
//
//

import Foundation

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
