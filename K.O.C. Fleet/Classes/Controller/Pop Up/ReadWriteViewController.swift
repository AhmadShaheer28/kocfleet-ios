//
//  ReadWriteViewController.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 05/07/2021.
//

import UIKit

class ReadWriteViewController: UIViewController {

    //MARK: - Outlets
    
    
    //MARK: - Variables
    
    var delegate: ActionDelegate?
    
    
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
    
    @IBAction func onCrossTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onReadTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.onReadTapped()
        }
    }
    @IBAction func onWriteTapped(_ sender: UIButton) {
        dismiss(animated: true) {
            self.delegate?.onWriteTapped()
        }
    }
    
    //MARK: - Data Source
    
    
    //MARK: - Private Methods

}
