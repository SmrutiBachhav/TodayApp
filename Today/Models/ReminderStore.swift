//
//  ReminderStore.swift
//  Today
//
//  Created by Smruti Bachhav on 09/04/25.
//
//creating a reminder store abstraction to facilitate the persistence(saving) of reminders data.


import EventKit
import Foundation

final class ReminderStore {
    static let shared = ReminderStore()
    
    private let ekStore = EKEventStore()
    //computed property named isAvailable that returns true if the reminder authorization status is .fullAccess.
    //use this property to determine if the user has granted access to their reminder data.
    var isAvailable: Bool {
        EKEventStore.authorizationStatus(for: .reminder) == .fullAccess
    }
    
    //function that can throw the errors you just defined.
    //The function will do nothing if the user has granted access, ask permission if the user hasn’t yet decided, or throw an error for other conditions.
    func requestAccess() async throws {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        switch status {
        case .fullAccess:
            return
        case .restricted, .writeOnly:
            throw TodayError.accessRestricted
        case .notDetermined:
            let accessGranted = try await ekStore.requestFullAccessToReminders()
            guard accessGranted else {
                throw TodayError.accessDenied
            }
        case .denied:
            throw TodayError.accessDenied
        @unknown default:
            throw TodayError.unknown
        }
    }
    
    //async throwing function named readAll that returns an array of Reminder.
    func readAll() async throws -> [Reminder] {
        //guard statement that throws an error if reminder access is unavailable.
        guard isAvailable else {
            throw TodayError.accessDenied
        }
        //This predicate narrows the results to only reminder items. If you choose, you can further narrow the results to reminders from specific calendars.
        let predicate = ekStore.predicateForReminders(in: nil)
        //awaits the result of reminders(matching:).
        let ekReminders = try await ekStore.reminders(matching: predicate)
        // stores the result of mapping data from [EKReminder] to [Reminder].
        let reminders: [Reminder] = try ekReminders.compactMap { ekReminder in
            //returns the converted reminder.
            do {
                return try Reminder(with: ekReminder)
            } catch TodayError.reminderHasNoDueDate {
                //By returning nil, you instruct the compact map to discard this reminder from the destination collection.
                return nil
            }
        }
        //The resulting array contains only the reminders that have alarms corresponding to their due dates.
        return reminders
    }
    //create a throwing function named save(_:) that accepts a Reminder and has a discardable return type of Reminder.ID.
    @discardableResult
    func save(_ reminder: Reminder) throws -> Reminder.ID {
        //throws an error if reminder access is unavailable.
        guard isAvailable else {
            throw TodayError.accessDenied
        }
        let ekReminder: EKReminder
        do {
            ekReminder = try read(with: reminder.id)
        } catch {
            //Failing to find a reminder with the corresponding identifier doesn’t indicate an error. Rather, it indicates that the user is saving a new reminder.
            ekReminder = EKReminder(eventStore: ekStore)
        }
        ekReminder.update(using: reminder, in: ekStore)
        try ekStore.save(ekReminder, commit: true)
        return ekReminder.calendarItemIdentifier
    }
    
    //delete reminders from EventKit when a user removes them from Today.
    func remove(with id: Reminder.ID) throws {
        guard isAvailable else {
            throw TodayError.accessDenied
        }
        let ekReminder = try read(with: id)
        try ekStore.remove(ekReminder, commit: true)
    }
    
    //function that retrieves a reminder from EventKit by using a specific identifier.
    //EventKit contains all data from a user’s calendar, not just reminder data. You’ll query for a calendar item that matches your reminder identifier.
    private func read(with id: Reminder.ID) throws -> EKReminder {
        guard let ekReminder  = ekStore.calendarItem(withIdentifier: id) as? EKReminder else {
            throw TodayError.failedReadingReminders
        }
        return ekReminder
    }
    
}
