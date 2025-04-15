//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by Smruti Bachhav on 01/04/25.
//

import UIKit

extension ReminderViewController {
    //show four discrete reminder details in the detail view: title, date, time, and notes.
    enum Row: Hashable {
        case header(String)
        case date
        case notes
        case time
        case title
        case editableDate(Date)
        case editableText(String?)
        
        //a computed property named imageName that returns an appropriate SF Symbol name for each case.
        var imageName: String? {
            switch self {
            case .date: return "calendar.circle"
            case .notes: return "pencil.circle.fill"
            case .time: return "clock"
            default: return nil ?? "pencil.and.circle"
            }
        }
        
        //computed property named image that returns an image based on the image name.
        var image: UIImage? {
            guard let imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        //a computed property named textStyle that returns the text style associated with each case.
        var textStyle: UIFont.TextStyle {
            switch self {
            case.title: return .headline
            default: return .subheadline
            }
        }
    }
    
}
