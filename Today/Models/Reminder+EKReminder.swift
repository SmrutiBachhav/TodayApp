//
//  Reminder+EKReminder.swift
//  Today
//
//  Created by Smruti Bachhav on 09/04/25.
//
//If a reminder has an alarm, the system presents a notification to the user when the reminder is due.

import EventKit
import Foundation

extension Reminder {
    //throwing initializer that accepts an EKReminder.
    init(with ekReminder: EKReminder) throws {
        //Add a guard statement that binds the absolute date of a reminder’s first alarm. In the else clause, throw an error.
        guard let dueDate = ekReminder.alarms?.first?.absoluteDate else {
            throw TodayError.reminderHasNoDueDate
        }
        id = ekReminder.calendarItemIdentifier
        title = ekReminder.title
        self.dueDate = dueDate
        notes = ekReminder.notes
        isComplete = ekReminder.isCompleted
    }
}
