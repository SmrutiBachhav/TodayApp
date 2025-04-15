//
//  TextViewContentView.swift
//  Today
//
//  Created by Smruti Bachhav on 05/04/25.
//
//add the text view as a subview, and customize its size, background, and font style.
//Users can enter substantial text in the editable notes text view. 
import UIKit

class TextViewContentView: UIView, UIContentView {
    //Add text view and configuration properties, an initializer that sets the configuration property, and a configure(configuration:) function that sets the text view’s text property.
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = { _ in }
        //This function is the final behavior that you need to include to conform to the UIContentConfiguration protocol.
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(self)
        }
    }
    let textView = UITextView()
    var configuration: UIContentConfiguration{
        didSet {
            configure(configuration: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        // text view as a pinned subview with a height of 200.
        addPinnedSubview(textView, height: 200)
        //background color to transparent to view the background behind the text view.
        textView.backgroundColor = nil
        //You’re assigning this content view to be the delegate of the text view control. As such, it monitors the text view control for user interactions and responds accordingly.
        textView.delegate = self
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textView.text = configuration.text
    }
}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}

//You’ll assign a helper object, or delegate, for the text view. Objects that you assign as a text view delegate and that conform to the UITextViewDelegate protocol can intervene when the text view detects a user interaction.


extension TextViewContentView: UITextViewDelegate {
    //The text view’s delegate calls this function whenever it detects a user interaction. Other common interactions include textViewDidBeginEditing(_:) and textViewDidEndEditing(_:).
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? TextViewContentView.Configuration else { return }
        configuration.onChange(textView.text)
    }
}
