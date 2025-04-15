//
//  EKReminder+Reminder.swift
//  Today
//
//  Created by Smruti Bachhav on 10/04/25.
//
//Now that you’ve retrieved the EventKit record, you need to update it to reflect changes that the user made. In this section, you’ll add a method to the EKReminder class that allows its instances to update themselves using a Reminder object.

import EventKit
import Foundation

extension EKReminder {
    func function(using reminder: Reminder, in store: EKEventStore) {
        title = reminder.title
        notes = reminder.notes
        isCompleted = reminder.isComplete
        calendar = store.defaultCalendarForNewReminders()
        //Iterate through the alarms, removing any alarm that doesn’t correspond to the reminder’s due date.
        alarms?.forEach { alarm in
            guard let absoluteDate = alarm.absoluteDate else { return }
            //The comparison determines the dates to be the same if they occur during the same minute.
            let comparison = Locale.current.calendar.compare(
                reminder.dueDate,  to: absoluteDate, toGranularity: .minute)
            if comparison != .orderedSame {
                    removeAlarm(alarm)
            }
        }
        //If the reminder has no alarms, add an alarm for the due date.
        //The reminder must have one alarm in order to trigger a system notification when it’s due.
        if !hasAlarms {
            addAlarm(EKAlarm(absoluteDate: reminder.dueDate))
        }
    }
    
        func update(using reminder: Reminder, in store: EKEventStore) {
            self.title = reminder.title
            self.notes = reminder.notes
            self.isCompleted = reminder.isComplete
            self.calendar = store.defaultCalendarForNewReminders()

            // Example: Add alarm based on due date
            self.alarms = [EKAlarm(absoluteDate: reminder.dueDate)]
        
    }

}
