//
//  LoginController.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 2.01.2024.
//

import UIKit
import JGProgressHUD

class RegistrationController: UIViewController{
    
    //MARK: - Properties
    
    private var viewModel = RegistrationViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    private lazy var selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let fullnameTextField = CustomTextField(placeholder: "Fullname")
    
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureText: true)
    
    private var profileImage: UIImage?
    
    private lazy var authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleRegisterUser), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an acccount?  ", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFieldObservers()
        configureUI()
    }
    
    //MARK: - Actions
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }else if sender == fullnameTextField{
            viewModel.fullname = sender.text
        }else{
            viewModel.password = sender.text
        }
        chechFromStatus()
    }
    
    @objc func handleRegisterUser(){
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let fullname = fullnameTextField.text,
              let profileImage = profileImage else{return}
        
        let hud = JGProgressHUD(style: .dark)
        hud.show(in: view)
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, profileImage: profileImage)
        AuthService.registerUser(withCredentials: credentials) { error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            hud.dismiss()
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func handleSelectPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helpers
    
    func chechFromStatus(){
        if viewModel.formIsValid{
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        }else{
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    
    private func configureUI(){
        configureGradientLayer()
        
        view.addSubview(selectPhotoButton)
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.setDimensions(height: 275, width: 275)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 8)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, fullnameTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: selectPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
    }
    
    func configureTextFieldObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
}

//MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        
        profileImage = image
        selectPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.borderColor = UIColor.white.cgColor
        selectPhotoButton.layer.borderWidth = 3
        selectPhotoButton.layer.cornerRadius = 10
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        
        dismiss(animated: true, completion: nil)
    }
}
