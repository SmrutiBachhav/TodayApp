//
//  UIContentConfiguration+Stateless.swift
//  Today
//
//  Created by Smruti Bachhav on 05/04/25.
//

import UIKit

extension UIContentConfiguration {
    //allows a UIContentConfiguration to provide a specialized configuration for a given state
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
