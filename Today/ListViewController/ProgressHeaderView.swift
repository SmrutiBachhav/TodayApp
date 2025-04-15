//
//  ProgressHeaderView.swift
//  Today
//
//  Created by Smruti Bachhav on 08/04/25.
//

import UIKit

class ProgressHeaderView: UICollectionReusableView {
    //The element kind specifies a type of supplementary view that the collection view can present.
    static var elementKind: String { UICollectionView.elementKindSectionHeader }
    
    var progress: CGFloat = 0 {
        //Add an observer to the progress property that updates the height constraint of the lower view when the value of progress changes.
        didSet {
            //Calling setNeedsLayout() invalidates the current layout and triggers an update.
            setNeedsLayout()
            heightConstraint?.constant = progress * bounds.height
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.layoutIfNeeded()
            }
        }
    }
    
    private let upperView = UIView(frame: .zero)
    private let lowerView = UIView(frame: .zero)
    private let containerView = UIView(frame: .zero)
    private var heightConstraint: NSLayoutConstraint?
    private var valueFormat: String {
        NSLocalizedString("%d percent", comment: "progress percentage value format")
    }
    
    //Override the designated initializer so that you can perform some custom initialization, and call super.init.
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareSubviews()
 //isAccessibilityElement indicates whether the element is an accessibility element that an assistive technology can access. Standard UIKit controls enable this value by default.
        isAccessibilityElement = true
        accessibilityLabel = NSLocalizedString("Progress", comment: "Progress view accessibility label")
        accessibilityTraits.update(with: .updatesFrequently)
    }
    
    //implement init(coder:), which is a requirement when subclassing any UIView.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessibilityValue = String(format: valueFormat, Int(progress * 100.0))
        heightConstraint?.constant = progress * bounds.height
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 0.5 * containerView.bounds.width
    }
    
    private func prepareSubviews() {
        //function named prepareSubviews to add the subviews to the view hierarchy.
        //Add upperView and lowerView as subviews of containerView. And add containerView as a subview of the progress header view.
        containerView.addSubview(upperView)
        containerView.addSubview(lowerView)
        addSubview(containerView)
        
        //Disable translatesAutoresizingMaskIntoConstraints for the subviews so that you can modify the constraints for the subviews.
        //When true, the system automatically specifies a view’s size and position.
        upperView.translatesAutoresizingMaskIntoConstraints = false
        lowerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        //Maintain a 1:1 fixed aspect ratio for the superview and container views.
        heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1).isActive = true
        
        //Center the container view horizontally and vertically in the layout frame.
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        //Scale the container view to 85 percent of the size of its progress header view.
        containerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.85).isActive = true
        
        //Vertically constrain the subviews by setting the following
        upperView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        upperView.bottomAnchor.constraint(equalTo: lowerView.topAnchor).isActive = true
        lowerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        //Horizontally constrain the subviews by setting the upperView and lowerView leading and trailing anchors equal to those of the progress header view.
        upperView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        upperView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        lowerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        lowerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        heightConstraint = lowerView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint?.isActive = true
        
        //Assign background color to views
        //container view background to clear because it doesn’t need any visual decoration.
        backgroundColor = .clear
        containerView.backgroundColor = .clear
        upperView.backgroundColor = .todayProgressUpperBackground
        lowerView.backgroundColor = .todayProgressLowerBackground
        
        
    }
}
