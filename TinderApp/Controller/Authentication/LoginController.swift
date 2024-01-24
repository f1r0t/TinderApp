//
//  LoginController.swift
//  TinderApp
//
//  Created by Fırat AKBULUT on 2.01.2024.
//

import UIKit
import JGProgressHUD

protocol AuthenticationDelegate: AnyObject{
    func authenticationComplete()
}

class LoginController: UIViewController{
    
    //MARK: - Properties
    
    private var viewModel = LoginViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "app_icon")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        return iv
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passwordTextField = CustomTextField(placeholder: "Password", isSecureText: true)
    
    private lazy var authButton: AuthButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private lazy var goToRegistrationButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an acccount?  ", attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 16)])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [.foregroundColor: UIColor.white, .font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowRegistration), for: .touchUpInside)
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
        }else{
            viewModel.password = sender.text
        }
        checkFromStatus()
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else{return}
        
        let hud = JGProgressHUD(style: .dark)
        //hud.textLabel.text = "Logging In"
        hud.show(in: view)
        
        AuthService.logUserIn(email: email, password: password) { result, error in
            if let error = error{
                print(error.localizedDescription)
                hud.dismiss()
                return
            }
            hud.dismiss()
            self.delegate?.authenticationComplete()
        }
    }
    
    @objc func handleShowRegistration(){
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Helpers
    
    func checkFromStatus(){
        if viewModel.formIsValid{
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        }else{
            authButton.isEnabled = false
            authButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    private func configureUI(){
        navigationController?.navigationBar.isHidden = true
        configureGradientLayer()

        view.addSubview(iconImageView)
        iconImageView.centerX(inView: view)
        iconImageView.setDimensions(height: 100, width: 100)
        iconImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, authButton])
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top: iconImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(goToRegistrationButton)
        goToRegistrationButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
    }
    
    func configureTextFieldObservers(){
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
}
