//
//  Utilities.swift
//  TwitterTutorial
//
//  Created by Grazi  Berti on 28/09/22.
//

import UIKit

class Utilities {
    func inputContainerView(withImage image: UIImage?, textField: UITextField) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        let dividerView = UIView()
        
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        imageView.image = image
        imageView.tintColor = .white
        
        dividerView.backgroundColor = .white
        
        view.addSubview(imageView)
        view.addSubview(textField)
        view.addSubview(dividerView)

        imageView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                         paddingLeft: 4, paddingBottom: 8)
        imageView.setDimensions(width: 24, height: 24)
        
        textField.anchor(left: imageView.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                         paddingLeft: 8, paddingBottom: 8)
        
        dividerView.anchor(left: imageView.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                           paddingLeft: 2, height: 0.75)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return textField
    }
}
