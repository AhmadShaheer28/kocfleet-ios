//
//  AuthViewController.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 05/07/2021.
//

import UIKit

class AuthViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    //MARK: - Variables
    
    var hasWriteAuth = false
    var delagate: WriteAuthDelegate?
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - View Setup
    func setupView() {
        userNameTextField.setPaddingPoints(10)
        passwordTextField.setPaddingPoints(10)
        userNameTextField.placeHolderColor = #colorLiteral(red: 0.6652657986, green: 0.661313355, blue: 0.668305397, alpha: 1)
        passwordTextField.placeHolderColor = #colorLiteral(red: 0.6652657986, green: 0.661313355, blue: 0.668305397, alpha: 1)
        
    }
    
    
    //MARK: - Selector Methods
    
    
    //MARK: - Actions
    
    @IBAction func onEnterTapped(_ sender: UIButton) {
        if userNameTextField.text?.isEmptyOrWhitespace() == true {
            self.showAlert(title: "Error", message: "Please enter username")
        } else if passwordTextField.text?.isEmptyOrWhitespace() == true {
            self.showAlert(title: "Error", message: "Please enter password")
        } else {
            if !hasWriteAuth {
                if userNameTextField.text == "FMT", passwordTextField.text == "2015" {
                    navigateToMainScreen()
                } else {
                    self.showAlert(title: "Error", message: "Invalid Username or Password!")
                }
            } else {
                if userNameTextField.text == "Kuwait", passwordTextField.text == "2040" {
                    writeAuthVerfied()
                } else {
                    self.showAlert(title: "Error", message: "Invalid Username or Password!")
                }
            }
        }
    }
    
    @IBAction func onCrossTapped(_ sender: UIButton) {
        
    }
    
    
    
    //MARK: - Data Source
    
    
    //MARK: - Private Methods
    
    private func navigateToMainScreen() {
        Utility.setHomeControllerAsRootViewController()
    }
    
    private func writeAuthVerfied() {
        dismiss(animated: false) {
            self.delagate?.onWriteAuthVerfied()
        }
    }
    
}
