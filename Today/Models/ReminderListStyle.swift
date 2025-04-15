//
//  ReminderListStyle.swift
//  Today
//
//  Created by Smruti Bachhav on 08/04/25.
//

import Foundation

enum ReminderListStyle: Int {
    case today
    case future
    case all
    
    //name computed property that returns the name of each style.
    var name: String {
        switch self {
        case .today:
            return NSLocalizedString("Today", comment: "Today style name")
        case .future:
            return NSLocalizedString("Future", comment: "Fututre style name")
        case .all:
            return NSLocalizedString("All", comment: "All style name")
        }
    }

    //ReminderListViewController displays only reminders with due dates that match the list style that the user selects.
    func shouldInclude(date: Date) -> Bool {
        //The value of isInToday is true if the date that the caller passes to the function is today and is false if it is not. Locale.current.calendar is the current calendar based on the user’s region settings.
        let isInToday = Locale.current.calendar.isDateInToday(date)
        //Switch over self, and return a Boolean value that indicates whether each style includes the given date.
        switch self {
        case .today:
            return isInToday
        case .future:
            return (date > Date.now) && !isInToday
        case .all:
            return true
        }
    }
}
