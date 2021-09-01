//
//  SelectedSheetViewController.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 23/07/2021.
//

import UIKit
import SpreadsheetView

class SelectedSheetViewController: UIViewController {
    
    //MARK: - Outlets
    
    
    
    //MARK: - Variables
    
    var rows:Int?
    var colums:Int?
    var fileName = ""
    var isFifiPortCol = -1
    var finalData = [[CellModel]()]
    var selectedCol = -1
    private var fifiPortNum = 0
    private let spreadsheetView = SpreadsheetView()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        spreadsheetView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    
    //MARK: - View Setup
    func setupView() {
        getTotalColumnsOfSheet()
        spreadsheetView.register(LabelClass.self, forCellWithReuseIdentifier: LabelClass.identifier)
        spreadsheetView.gridStyle = .solid(width: 1, color: .black)
        spreadsheetView.delegate = self
        spreadsheetView.dataSource = self
        self.view.addSubview(spreadsheetView)
        spreadsheetView.reloadData()
    }
    
    
    //MARK: - Selector Methods
    
    
    //MARK: - Actions
    
    
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
    
}



// MARK: - SpreadsheetView Delegate

extension SelectedSheetViewController: SpreadsheetViewDelegate,SpreadsheetViewDataSource {
    
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
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: LabelClass.identifier, for: indexPath) as! LabelClass
        if finalData[indexPath.row].count == 0 {
            cell.setup(with: "")
            cell.setLabelBackgroundColor(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            return cell
        }
        if selectedCol != -1 {
            if colums == 5 {
                if indexPath.column == (colums! - 1) {
                    cell.setup(with: finalData[indexPath.row][selectedCol].value)
                    cell.setLabelBackgroundColor(with: finalData[indexPath.row][selectedCol].color)
                    return cell
                } else if indexPath.column == (colums! - 2) {
                    cell.setup(with: finalData[indexPath.row][selectedCol].value)
                    cell.setLabelBackgroundColor(with: finalData[indexPath.row][selectedCol].color)
                    return cell
                }
            } else {
                if indexPath.column == (colums! - 1) {
                    cell.setup(with: finalData[indexPath.row][selectedCol].value)
                    cell.setLabelBackgroundColor(with: finalData[indexPath.row][selectedCol].color)
                    return cell
                }
            }
        }
        cell.setup(with: finalData[indexPath.row][indexPath.column].value)
        cell.setLabelBackgroundColor(with: finalData[indexPath.row][indexPath.column].color)
        return cell
    }
    
    
}
