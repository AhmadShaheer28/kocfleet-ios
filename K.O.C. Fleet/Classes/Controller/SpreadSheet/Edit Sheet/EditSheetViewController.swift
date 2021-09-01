//
//  EditSheetViewController.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 24/07/2021.
//

import UIKit
import SpreadsheetView

class EditSheetViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var spreadsheetView: SpreadsheetView!
    
    
    //MARK: - Variables
    
    var rows:Int?
    var colums:Int?
    var fileName = ""
    var isFifiPortCol = -1
    var finalData = [[CellModel]()]
    var selectedCol = -1
    private var fifiPortNum = 0
    private var array = [String]()
    var delegate: SaveDataDelegate?
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
    //MARK: - View Setup
    func setupView() {
        getTotalColumnsOfSheet()
        spreadsheetView.register(TextFieldClass.self, forCellWithReuseIdentifier: TextFieldClass.identifier)
        spreadsheetView.gridStyle = .solid(width: 1, color: .black)
        spreadsheetView.delegate = self
        spreadsheetView.dataSource = self
        self.view.addSubview(spreadsheetView)
        spreadsheetView.reloadData()
    }
    
    
    //MARK: - Selector Methods
    
    
    //MARK: - Actions
    
    @IBAction func onSaveTapped(_ sender: UIButton) {
        if selectedCol == -1 {
            for col in (0..<colums!) {
                let index = IndexPath(row: getLastRowNumber(), column: col)
                if let cell = spreadsheetView.cellForItem(at: index) as? TextFieldClass {
                    array.append((cell.label.text ?? "") as String)
                } else {
                    array.append("~")
                }
            }
            delegate?.onSavedDataReceived(with: array)
        } else {
            for row in (0..<rows!+2) {
                let index = IndexPath(row: row, column: selectedCol)
                if let cell = spreadsheetView.cellForItem(at: index) as? TextFieldClass {
                    array.append((cell.label.text ?? "") as String)
                } else {
                    array.append("~")
                }
            }
            delegate?.onSavedColDataReceived(with: array)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Data Source
    
    
    
    //MARK: - Private Methods
    
    private func getTotalColumnsOfSheet() {
        if selectedCol != -1 {
            if fileName == Constants.CERTIFICATES {
                colums = 3
            } else if isFifiPortCol != -1 {
                colums = 5
                if selectedCol == 4 {
                    fifiPortNum = 5
                } else {
                    fifiPortNum = 4
                }
            } else {
                colums = 4
            }
        }
    }
    
    private func getLastRowNumber() -> Int {
        if fileName == Constants.EQUIPMENTS {
            return 3
        } else {
            return 2
        }
    }
    
}



// MARK: - SpreadsheetView Delegate

extension EditSheetViewController: SpreadsheetViewDelegate, SpreadsheetViewDataSource {
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow column: Int) -> CGFloat {
        50
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        120
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        colums ?? 0
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        if fileName == Constants.CONDITION {
            return 70
        }
        return rows ?? 0
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TextFieldClass.identifier, for: indexPath) as! TextFieldClass
        cell.label.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if finalData[indexPath.row].count == 0 {
            cell.setup(with: "")
            cell.setLabelBackgroundColor(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            return cell
        }
        if selectedCol != -1 {
            if indexPath.column == (colums! - 1) {
                cell.setup(with: finalData[indexPath.row][selectedCol].value)
                cell.setLabelBackgroundColor(with: finalData[indexPath.row][selectedCol].color)
                return cell
            }
        }
        
        cell.setup(with: finalData[indexPath.row][indexPath.column].value)
        cell.setLabelBackgroundColor(with: finalData[indexPath.row][indexPath.column].color)
        return cell
    }
    
    
    //MARK: - UITextFieldDelegate
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
    }
    
}
