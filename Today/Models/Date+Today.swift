//
//  Date+Today.swift
//  Today
//
//  Created by Smruti Bachhav on 18/03/25.
//

import Foundation

extension Date {
    //computed property for formatted and localized string representation of day and time
    var dayAndTimeText: String {
        //The system formats the string representation of the date and time for the current locale using a default style. Passing .omitted for the date style creates a string of only the time component.
        let timeText = formatted(date: .omitted, time: .shortened)
        //if-else statement that tests whether this date is in the current calendar day.
        if Locale.current.calendar.isDateInToday(self){
            //The comment parameter provides the translator with context about the localized string’s presentation to the user.
            let timeFormat = NSLocalizedString("Today at %@", comment: "Today at time format string")
            return String(format: timeFormat, timeText)
        }else{
            let dateText = formatted(.dateTime.month(.abbreviated).day())
            let dateAndTimeFormat = NSLocalizedString("%@ at %@", comment: "Date and time format string")
            return String(format: dateAndTimeFormat, dateText, timeText)
        }
    }
    //computed property for formatted and localized string representation of date only
    var dayText: String {
        if Locale.current.calendar.isDateInToday(self) {
            return NSLocalizedString("Today", comment: "Today due date description")
        }else {
            return formatted(.dateTime.month().day().weekday(.wide))
        }
    }

}
