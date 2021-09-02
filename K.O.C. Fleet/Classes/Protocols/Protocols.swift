//
//  Protocols.swift
//  lafa
//
//  Created by Ahmad Shaheer on 22/06/2021.
//

import Foundation


protocol ActionDelegate {
    func onReadTapped()
    func onWriteTapped()
}

protocol WriteAuthDelegate {
    func onWriteAuthVerfied()
}

protocol SaveDataDelegate {
    func onSavedDataReceived(with savedRow: [String])
    func onSavedColDataReceived(with savedCol: [String])
}

protocol TextfieldChangedText {
    func onTextChanged(to text: String, at index: Int)
}

