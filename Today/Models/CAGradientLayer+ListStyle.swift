//
//  CAGradientLayer+ListStyle.swift
//  Today
//
//  Created by Smruti Bachhav on 09/04/25.
//

import UIKit

extension CAGradientLayer {
    // function named gradientLayer(for:in:) that accepts parameters for style and frame and returns CAGradientLayer.
    static func gradientLayer(for style: ReminderListStyle, in frame: CGRect) -> Self{
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        return layer
    }
    
    //function named colors(for:) that accepts a list style and returns an array of CGColor.
    private static func colors(for style: ReminderListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch style {
//assign beginning and ending colors for each of the filters of the segmented control: Today, Future, and All. Assigning a different gradient background to each filter creates a visual cue that each view loads different reminders.
        case .all:
            beginColor = .todayGradientAllBegin
            endColor = .todayGradientAllEnd
        case .future:
            beginColor = .todayGradientFutureBegin
            endColor = .todayGradientFutureEnd
        case .today:
            beginColor = .todayGradientTodayBegin
            endColor = .todayGradientTodayEnd
        }
        return [beginColor.cgColor, endColor.cgColor]
    }
}
