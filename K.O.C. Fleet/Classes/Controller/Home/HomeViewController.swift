//
//  HomeViewController.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 05/07/2021.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Outlets
    
    
    //MARK: - Variables
    
    private var fileName = ""
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - View Setup
    func setupView() {
        
    }
    
    
    //MARK: - Selector Methods
    
    
    //MARK: - Actions
    
    @IBAction func onBoatConditionTapped(_ sender: UIButton) {
        fileName = Constants.CONDITION
        openActionDialog()
    }
    @IBAction func onCertificateTapped(_ sender: UIButton) {
        fileName = Constants.CERTIFICATES
        openActionDialog()
    }
    @IBAction func onSafetyEquipmentTapped(_ sender: UIButton) {
        fileName = Constants.EQUIPMENTS
        openActionDialog()
    }
    
    //MARK: - Data Source
    
    
    //MARK: - Private Methods
    
    private func openActionDialog() {
        let vc = ReadWriteViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
}


//MARK: - Action Delegate
extension HomeViewController: ActionDelegate {
    func onReadTapped() {
        let vc = SpreadsheetViewController()
        vc.fileName = fileName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func onWriteTapped() {
        let vc = AuthViewController()
        vc.hasWriteAuth = true
        vc.delagate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}


extension HomeViewController: WriteAuthDelegate {
    func onWriteAuthVerfied() {
        let vc = SpreadsheetViewController()
        vc.fileName = fileName
        vc.hasWriteAuth = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

