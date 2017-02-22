//
//  CronJob.swift
//  Swift-Cron
//
//  Created by Ryan Collins on 2/22/17.
//
//

import Foundation

public class CronJob {
    
    private var _id: UUID
    private var _method: () -> Void
    private var _date: Date
    private var _allowsSimultaneous: Bool
    private var _repeats: Bool
    
    var id: UUID {
        get {
            return _id
        }
    }
    
    var method: () -> Void {
        get {
            return _method
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
    
    init(_ method: @escaping () -> Void, executeAfter date: Date, allowsSimultaneous: Bool = false, repeats: Bool = false) {
        _id = UUID()
        _method = method
        _date = date
        _allowsSimultaneous = allowsSimultaneous
        _repeats = repeats
    }
}
