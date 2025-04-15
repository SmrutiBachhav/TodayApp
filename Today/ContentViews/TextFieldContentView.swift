//
//  TextFieldContentView.swift
//  Today
//
//  Created by Smruti Bachhav on 05/04/25.
//
//You’ll use the TextFieldContentView.Configuration type to customize the content of your configuration and your view.

//The initializer for TextFieldContentView takes a UIContentConfiguration. This UIContentConfiguration, however, has a string that represents the content packaged inside the text field.

import UIKit

class TextFieldContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        //This empty closure holds the behavior that you’d like to perform when the user edits the text in the text field.
        var onChange: (String) -> Void = { _ in }
        //This function is the final behavior that you need to include to conform to the UIContentConfiguration protocol.
        func makeContentView() -> UIView & UIContentView {
            return TextFieldContentView(self)
        }
    }
    let textField = UITextField()
    var configuration: UIContentConfiguration {
        //Add a didSet observer that calls the new configure method to the configuration property.
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
        addPinnedSubview(textField, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        textField.addTarget(self, action: #selector(didChange(_:)), for: .editingChanged)
        textField.clearButtonMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(Coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        //Cast the configuration parameter as TextFieldContentView.Configuration. Otherwise, return to the function calling point.
        guard let configuration = configuration as? Configuration else { return }
        textField.text = configuration.text
    }
    
    @objc private func didChange(_ sender: UITextField) {
         guard let configuration = configuration as? TextFieldContentView.Configuration else { return }
         configuration.onChange(textField.text ?? "")
     }
}
//You’ll extend the behavior of UICollectionViewListCell to return a custom configuration that you’ll pair with the custom TextFieldContentView.

extension UICollectionViewListCell {
    //function named textFieldConfiguration that returns a new TextFieldContentView.Configuration.
    func textFieldConfiguration() -> TextFieldContentView.Configuration {
        TextFieldContentView.Configuration()
    }
}
