//
//  RegistrationController.swift
//  TwitterTutorial
//
//  Created by Grazi  Berti on 28/09/22.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    //MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoro), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(systemName: "envelope")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        return view
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let image = UIImage(systemName: "envelope")
        let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
        return view
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var fullNameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Full Name")
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Username")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let signUoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account?", " Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectiors
    
    @objc
    func handleRegistration() {
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile picture")
            return
        }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        let storageRef = Storage.storage().reference()
        
        //Turn our image into data
        let imageData = profileImage.jpegData(compressionQuality: 0.8)
        guard imageData != nil else { return }
        
        //Specify the file path and name
        let fileRef = storageRef.child("images/\(UUID().uuidString).jpg")
        
        //Upload that data
        let uploadTask = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            //Check for error
            if error == nil && metadata != nil {
                print("Oi")
            }
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { autoDataResul, error in
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
                return
            }
            
            guard let uid = autoDataResul?.user.uid else { return }
            
            let values = ["email": email,
                          "username": username,
                          "fullname": fullName,
                        ]
            
            Database.database().reference().child("users").updateChildValues(values) { (error, ref) in
                print("DEBUG: Sucessfuly update user information ...")
            }
        }
    }
    
    @objc
    func handleAddProfilePhoro() {
        present(imagePicker, animated: true)
    }
    
    @objc
    func handleShowLogin() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Helpers
    
    func  configureUI() {
        view.backgroundColor = .twitterBlue
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor, paddingTop: 0)
        plusPhotoButton.setDimensions(width: 150, height: 150)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, fullNameContainerView, usernameContainerView, signUoButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)
    }
}

//MARK: UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        
        plusPhotoButton.layer.cornerRadius = 150 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true, completion: nil)
    }
}
