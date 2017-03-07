//
//  CronJob.swift
//  Swift-Cron
//
//  Created by Ryan Collins on 2/22/17.
//
//

import Foundation

public class CronJob: Equatable {
    
    private var _id: UUID
    var method: () -> Void
    private var _dates: [Date]
    private var _allowsSimultaneous: Bool
    private var _repeats: Bool
    private var _repeatInterval: TimeInterval?
    
    var id: UUID {
        get {
            return _id
        }
    }
    
    var dates: [Date] {
        get  {
            return _dates
        }
    }
    
    var allowsSimultaneious: Bool {
        get {
            return _allowsSimultaneous
        }
    }
    
    var repeats: Bool {
        get {
            return _repeats
        }
    }
    
    /// Creates a cron job to run with cron
    ///
    /// - Parameters:
    ///   - method: what func you want to run, cannot have a return value
    ///   - date: the Date you want to first run the application
    ///   - allowsSimultaneous: if more than one of this job can run at the same time, not currently implemented
    ///   - repeats: if you want the job to repeat after it's first run
    ///   - interval: how often, in seconds, the func should be called after it's been started first. Note: if it doesn't allow simulatneous running, it will not run until the first job has been executed (once implemented). If it does, it will start regardless to whether or not the last run has finished. 
    init(_ method: @escaping () -> (), executeAfter date: Date, allowsSimultaneous: Bool = false, repeats: Bool = false, repeatEvery interval: TimeInterval? = nil) {
        _id = UUID()
        self.method = method
        _dates = [date]
        _allowsSimultaneous = allowsSimultaneous
        _repeats = repeats
        _repeatInterval = interval
    }
    
    public func addNextRepeat() {
        if let interval = _repeatInterval {
            let last = self._dates.removeLast()
            self._dates.append(Date(timeInterval: interval, since: last))
        }
    }
    
    static public func == (lhs: CronJob, rhs: CronJob) -> Bool {
        return lhs.id == rhs.id
    }
}
