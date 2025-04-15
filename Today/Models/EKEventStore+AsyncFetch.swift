//
//  EKEventStore+AsyncFetch.swift
//  Today
//
//  Created by Smruti Bachhav on 09/04/25.
//
//create an asynchronous wrapper function that can return reminders inline.

import EventKit
import Foundation
//EKEventStore objects can access a user’s calendar events and reminders.
extension EKEventStore {
    //The async keyword after the function’s parameters indicates that this function can execute asynchronously.
    func reminders(matching predicate: NSPredicate) async throws -> [EKReminder] {
        //The await keyword indicates that your task suspends until the continuation resumes.
        try await withCheckedThrowingContinuation { continuation in
            fetchReminders(matching: predicate) { reminders in
                if let reminders {
                    continuation.resume(returning: reminders)
                }else {
                    continuation.resume(throwing: TodayError.failedReadingReminders)
                }
            }
        }
    }
}

