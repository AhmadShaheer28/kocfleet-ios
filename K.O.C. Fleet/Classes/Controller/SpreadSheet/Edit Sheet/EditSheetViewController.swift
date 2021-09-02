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
        setDataSource()
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
            delegate?.onSavedDataReceived(with: array)
        } else {
            delegate?.onSavedColDataReceived(with: array)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: - Data Source
    
    private func setDataSource() {
        if selectedCol != -1 {
            for row in finalData {
                for (index, col) in row.enumerated() {
                    if index == selectedCol {
                        array.append(col.value)
                    }
                }
            }
        } else {
            for (index, row) in finalData.enumerated() {
                if index == (finalData.count - 1) {
                    for col in row {
                        array.append(col.value)
                    }
                }
            }
        }
    }
    
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
        return rows ?? 0
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: TextFieldClass.identifier, for: indexPath) as! TextFieldClass
        if finalData[indexPath.row].count == 0 {
            cell.setup(with: "", -1)
            cell.setLabelBackgroundColor(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            return cell
        }
        if selectedCol != -1 {
            if indexPath.column == (colums! - 1) {
                cell.setup(with: finalData[indexPath.row][selectedCol].value, (indexPath.row - 2))
                cell.setLabelBackgroundColor(with: finalData[indexPath.row][selectedCol].color)
                cell.delegate = self
                return cell
            }
        }
        cell.delegate = self
        cell.setup(with: finalData[indexPath.row][indexPath.column].value, indexPath.column)
        cell.setLabelBackgroundColor(with: finalData[indexPath.row][indexPath.column].color)
        return cell
    }
    
    
}

    //MARK: - UITextField Delegate

extension EditSheetViewController: TextfieldChangedText {
    func onTextChanged(to text: String, at index: Int) {
        array[index] = text
    }
}
