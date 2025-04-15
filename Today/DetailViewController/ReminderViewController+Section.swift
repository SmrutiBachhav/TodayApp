//
//  ReminderViewController+Section.swift
//  Today
//
//  Created by Smruti Bachhav on 02/04/25.
//

//This file will contain the code to represent collection view sections.
//In view mode, all items are displayed in section 0. In editing mode, the title, date, and notes are separated into sections 1, 2, and 3, respectively.



import Foundation

extension ReminderViewController {
    //Start by defining an enumeration that represents the different sections of the collection view.
    //implicitly stores raw Int values and conforms to Hashable.
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes
        
        //name property that computes heading text for each section.
        var name: String {
            switch self {
            case .view: return ""
            case .title:
                return NSLocalizedString("Title", comment: "Title section name")
            case .date:
                return NSLocalizedString("Date", comment: "Date section name")
            case .notes:
                return NSLocalizedString("Notes", comment: "Notes section name")
            }
        }
    }
    
}
