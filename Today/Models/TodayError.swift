//
//  TodayError.swift
//  Today
//
//  Created by Smruti Bachhav on 09/04/25.
//

import Foundation
//Types conforming to LocalizedError can provide localized messages that describe their errors and why they occur.

enum TodayError: LocalizedError {
    case accessDenied
    case accessRestricted
    case failedReadingCalendarItem
    case failedReadingReminders
    case reminderHasNoDueDate
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return NSLocalizedString(
                "The app doesn't have permission to read reminders.", comment: "access denied error description")
        case .accessRestricted:
            return NSLocalizedString(
                "This device doen't allow access to reminder", comment: "access restricted error  description"
            )
        case .failedReadingCalendarItem:
            return NSLocalizedString("Failed to read calendar item", comment: "failed reading calendar item error description")
        case .failedReadingReminders:
            return NSLocalizedString(
                "Failed to read reminders.", comment: "failed reading reminders error description"
            )
        case .reminderHasNoDueDate:
            return NSLocalizedString(
                "A reminder has no due date.", comment: "reminder has no due date error description"
            )
        case .unknown:
            return NSLocalizedString("An unknown error occured.", comment: "unknown error description")
        }
    
    }
}
