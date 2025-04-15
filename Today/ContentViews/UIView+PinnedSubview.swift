//
//  UIView+PinnedSubview.swift
//  Today
//
//  Created by Smruti Bachhav on 05/04/25.
//

import UIKit

extension UIView {
    func addPinnedSubview(
        _ subview: UIView, height: CGFloat? = nil,
        insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    ) {
        //The addsubview(_:) method of UIView adds the subview to the bottom of the superview’s hierarchy.
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        //vertical padding paddin to top
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        //horizontal padding Add padding to the leading edge of the subview by specifying and activating a leading anchor constraint.
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        //padding to trailing edge
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1.0 * insets.right).isActive = true
        //padding to bottom of subview
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0 * insets.bottom).isActive = true
        if let height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
}
