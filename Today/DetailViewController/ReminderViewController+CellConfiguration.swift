//
//  ReminderViewController+CellConfiguration.swift
//  Today
//
//  Created by Smruti Bachhav on 03/04/25.
//

import UIKit

extension ReminderViewController {
    //start by extracting the appearance of the list view cells into a default configuration and applying this configuration to view mode.
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        return contentConfiguration
    }
    
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        //Retrieve the cell’s default configuration, and store it in a variable.
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        return contentConfiguration
    }
    
    //titleConfiguration(for:with:) function that accepts a cell and a title and returns a TextFieldContentView.Configuration.
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?) -> TextFieldContentView.Configuration {
        //Create and return a new text field configuration that uses the title.
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = title
        //add an onChange handler that assigns the new title to workingReminder.
        contentConfiguration.onChange = { [weak self] title in
            self?.workingReminder.title = title
        }
        return contentConfiguration

    }
    //functions that create and return a date picker configuration for the reminder’s date and a text view configuration for the reminder’s notes.
    
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DatePickerContentView.Configuration {
        var contentConfiguration = cell.datePickerConfiguration()
        contentConfiguration.date = date
        //To ensure the working reminder always has the latest user edits, you’ll update the working reminder’s date property any time the date in the picker control changes.
        contentConfiguration.onChange = { [weak self ] dueDate in
            self?.workingReminder.dueDate = dueDate
        }
        return contentConfiguration
    }
    
    func notesConfiguration(for cell: UICollectionViewListCell, with notes: String?) -> TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = notes
        //add an onChange handler that assigns the updated notes to workingReminder.
        contentConfiguration.onChange = { [weak self ] notes in
            self?.workingReminder.notes = notes
        }
        return contentConfiguration
    }
    
    //function named text(for:) that returns the text associated with the given row.
    func text(for row: Row) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title: return reminder.title
        default: return nil
        }
    }
}
