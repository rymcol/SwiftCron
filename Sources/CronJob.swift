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
    private var _date: Date
    private var _allowsSimultaneous: Bool
    private var _repeats: Bool
    
    var id: UUID {
        get {
            return _id
        }
    }
    
    var date: Date {
        get  {
            return _date
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
    
    init(_ method: @escaping () -> (), executeAfter date: Date, allowsSimultaneous: Bool = false, repeats: Bool = false) {
        _id = UUID()
        self.method = method
        _date = date
        _allowsSimultaneous = allowsSimultaneous
        _repeats = repeats
    }
    
    static public func == (lhs: CronJob, rhs: CronJob) -> Bool {
        return lhs.id == rhs.id
    }
}
