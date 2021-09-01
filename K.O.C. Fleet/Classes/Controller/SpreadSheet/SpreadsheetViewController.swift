//
//  SpreadsheetViewController.swift
//  K.O.C. Fleet
//
//  Created by Ahmad Shaheer on 05/07/2021.
//

import UIKit
import SpreadsheetView
import Firebase
import FirebaseFirestore

class SpreadsheetViewController: UIViewController {
    
    //MARK: - Outlets
    
    
    
    //MARK: - Variables
    var fileName: String?
    var hasWriteAuth = false
    private var rows:Int?
    private var colums:Int?
    private var changedRow = 0
    private let db = Firestore.firestore()
    private let spreadsheetView = SpreadsheetView()
    private var excelData = [String : [String : Any]]()
    private var excelSortedData = [[Any]()]
    private var finalData = [[CellModel]()]
    private var colors = [#colorLiteral(red: 0.9454951882, green: 0.9912433028, blue: 0.9403930306, alpha: 1), #colorLiteral(red: 0.7803921569, green: 0.7803921569, blue: 0.7803921569, alpha: 1), #colorLiteral(red: 0.9411764706, green: 0.6901960784, blue: 0.6, alpha: 1), #colorLiteral(red: 0.6862745098, green: 0.7019607843, blue: 0.9137254902, alpha: 1)]
    private let equipmentColor = [#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.7960784314, green: 0.968627451, blue: 0.7803921569, alpha: 1), #colorLiteral(red: 0.7803921569, green: 0.831372549, blue: 0.968627451, alpha: 1)]
    private let col0Color = #colorLiteral(red: 0.7960784314, green: 0.968627451, blue: 0.7803921569, alpha: 1)
    private var headerRowNum = 3
    private var selectedRowForEditing = -1
    private var selectedColumnForEditing = -1
    private var selectedColorForSingleFleetType = 0
    private var selectedColorForHeaderRow = 0
    let regDate = "[0-9]{2}-[0-9]{2}-[0-9]{2}"
    
    
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
        spreadsheetView.register(LabelClass.self, forCellWithReuseIdentifier: LabelClass.identifier)
        spreadsheetView.gridStyle = .solid(width: 1, color: .black)
        spreadsheetView.delegate = self
        spreadsheetView.dataSource = self
        self.view.addSubview(spreadsheetView)
        setHeaderRowNumber()
        getDataFromFirebase()
    }
    
    
    //MARK: - Selector Methods
    
    
    //MARK: - IBActions
    
    
    //MARK: - Data Source
    
    private func getDataFromFirebase() {
        Utility.showLoading()
        db.collection(fileName!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    self.excelData[document.documentID] = document.data()
                }
                self.sortExcelData()
                //self.addColorToDataCells()
                self.setColorsToTheCells()
                Utility.hideLoading()
                self.spreadsheetView.reloadData()
            }
        }
        
    }
    
    
    //MARK: - Private Methods
    
    private func sortExcelData() {
        rows = excelData.count + 2
        for (index, _) in excelData.enumerated() {
            for (_ ,data) in excelData.enumerated() {
                if data.key == "\(fileName!)ROW\(index)" {
                    if data.value.count > colums ?? 0 {
                        colums = data.value.count
                    }
                    excelSortedData.append(getSortedCellsData(data: data.value))
                    break
                }
            }
        }
    }
    
    private func getSortedCellsData(data: [String: Any]) -> [Any] {
        var cells = [Any]()
        for (index, _) in data.enumerated() {
            for (_, cellArr) in data.enumerated() {
                if cellArr.key == "cell\(index)" {
                    cells.append(cellArr.value)
                    break
                }
            }
        }
        return cells
    }
    
    
    /**
        * Sets color for each label *
     */
    private func setColorsToTheCells() {
        var colArr: CellModel
        var rowArr = [CellModel]()
        for (row , rowData) in excelSortedData.enumerated() {
            rowArr = [CellModel]()
            for (col , colData) in rowData.enumerated() {
                colArr = CellModel()
                if let data = colData as? String {
                    colArr.value = data
                }
                
                /// setting colors to 0, 1 & 2 columns of sheet 1, 2 & 3
                
                // sets 0 column color of each sheet
                if (0...rows!).contains(row), col == 0 {
                    colArr.color = col0Color
                }
                
                // sets 1 & 2 column color for sheet 1 & 3
                if fileName == Constants.CONDITION || fileName == Constants.EQUIPMENTS {
                    if (2...rows!).contains(row), col == 1 || col == 2 {
                        if let str = excelSortedData[row][col+1] as? String, col == 1 {
                            if !str.isEmpty {
                                selectedColorForSingleFleetType += 1
                            }
                        }
                        colArr.color = colors[selectedColorForSingleFleetType % 4]
                    }
                } else {
                    if (2...rows!).contains(row), col == 1 {
                        if row % 2 == 0 {
                            selectedColorForSingleFleetType += 1
                        }
                        colArr.color = colors[selectedColorForSingleFleetType % 4]
                    }
                }
                
                // sets header row color of each sheet
                if (0...colums!).contains(col), row == headerRowNum, fileName != Constants.EQUIPMENTS {
                    if col % 2 == 0 {
                        selectedColorForHeaderRow += 1
                    }
                    colArr.color = colors[selectedColorForHeaderRow % 4]
                } else if (3...colums!).contains(col), row == headerRowNum, fileName == Constants.EQUIPMENTS {
                    if col > 44, col < 80 {
                        selectedColorForHeaderRow = 1
                    } else if col > 80 {
                        selectedColorForHeaderRow = 2
                    }
                    colArr.color = equipmentColor[selectedColorForHeaderRow % 3]
                }
                
                // sets colors to some specific texts
                let datePred = NSPredicate(format:"SELF MATCHES %@", regDate)
                if let text = colData as? String {
                    if text.lowercased() == "in commission" || text.lowercased() == "ok" {
                        colArr.color = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 1)
                    } else if text.lowercased() == "out of commission" || text.lowercased() == "not ok" || text.lowercased() == "empty" {
                        colArr.color = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                    }
                    if datePred.evaluate(with: text) {
                        if Utility.matchDates(dataInString: text) < 1 {
                            colArr.color = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
                        }
                    }
                }
                
                
                
                
                
                rowArr.append(colArr)
            }
            finalData.append(rowArr)
        }
    }
    
    private func setHeaderRowNumber() {
        if fileName == Constants.CERTIFICATES {
            headerRowNum = 1
        } else {
            headerRowNum = 3
        }
    }
    
    private func getHeaderRowNumber() -> Int {
        if fileName == Constants.CONDITION {
            return 4
        } else if fileName == Constants.CERTIFICATES {
            return 2
        }
        return 4
    }
    
    private func goToSelectedSheetColViewController(indexPath: IndexPath) {
        let vc = SelectedSheetViewController()
        vc.finalData = self.finalData
        vc.rows = self.rows
        vc.colums = self.colums
        vc.fileName = self.fileName ?? ""
        vc.selectedCol = indexPath.column
        selectedColumnForEditing = indexPath.column
        if indexPath.column == 4 || indexPath.column == 5 {
            vc.isFifiPortCol = indexPath.column
        }
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func goToEditSheetColViewController(indexPath: IndexPath) {
        let vc = EditSheetViewController()
        vc.finalData = self.finalData
        vc.rows = self.rows
        vc.delegate = self
        vc.colums = self.colums
        vc.fileName = self.fileName ?? ""
        vc.selectedCol = indexPath.column
        selectedColumnForEditing = indexPath.column
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func goToSelectedSheetRowViewController(indexPath: IndexPath) {
        let vc = SelectedSheetViewController()
        vc.finalData.append(self.finalData[self.getHeaderRowNumber()])
        if fileName == Constants.EQUIPMENTS {
            vc.finalData.append(self.finalData[self.getHeaderRowNumber()+1])
        }
        vc.finalData.append(self.finalData[indexPath.row])
        vc.rows = vc.finalData.count
        vc.colums = self.colums
        vc.fileName = self.fileName ?? ""
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func goToEditSheetRowViewController(indexPath: IndexPath) {
        let vc = EditSheetViewController()
        vc.finalData.append(self.finalData[self.getHeaderRowNumber()])
        if fileName == Constants.EQUIPMENTS {
            vc.finalData.append(self.finalData[self.getHeaderRowNumber()+1])
        }
        vc.finalData.append(self.finalData[indexPath.row])
        selectedRowForEditing = indexPath.row
        vc.rows = vc.finalData.count
        vc.colums = self.colums
        vc.fileName = self.fileName ?? ""
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: false)
    }
    
}


    // MARK: - SpreadsheetView Delegate

extension SpreadsheetViewController: SpreadsheetViewDelegate,SpreadsheetViewDataSource {
    
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
        let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: LabelClass.identifier, for: indexPath) as! LabelClass
        if finalData[indexPath.row].count == 0 {
            cell.setup(with: "")
            cell.setLabelBackgroundColor(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            return cell
        }
        cell.setup(with: finalData[indexPath.row][indexPath.column].value)
        cell.setLabelBackgroundColor(with: finalData[indexPath.row][indexPath.column].color)
        return cell
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, didSelectItemAt indexPath: IndexPath) {
        if (0...self.colums!).contains(indexPath.row), indexPath.row == getHeaderRowNumber() {
            if !hasWriteAuth {
                goToSelectedSheetColViewController(indexPath: indexPath)
            } else {
                goToEditSheetColViewController(indexPath: indexPath)
            }
        } else if (0...self.rows!).contains(indexPath.row), indexPath.column == 0 {
            if !hasWriteAuth {
                goToSelectedSheetRowViewController(indexPath: indexPath)
            } else {
                goToEditSheetRowViewController(indexPath: indexPath)
            }
        }
    }
    
}


    // MARK: - Edited Data Delegate
extension SpreadsheetViewController: SaveDataDelegate {
    func onSavedDataReceived(with savedRow: [String]) {
        Utility.showLoading()
        for (row, rowData) in finalData.enumerated() {
            for (col, _) in rowData.enumerated() {
                if selectedRowForEditing == row {
                    if savedRow[col] == "~" {
                        continue
                    } else {
                        finalData[row][col].value = savedRow[col]
                    }
                }
            }
        }
        createDictionaryOfDataAndSaveToFirestore()
    }
    
    func onSavedColDataReceived(with savedCol: [String]) {
        Utility.showLoading()
        for (row, rowData) in finalData.enumerated() {
            for (col, _) in rowData.enumerated() {
                if selectedColumnForEditing == col {
                    if savedCol[row] == "~" {
                        continue
                    } else {
                        finalData[row][col].value = savedCol[row]
                    }
                }
            }
        }
        createDictionaryOfDataAndSaveToFirestore()
    }

    
    //MARK: - Private Functions
    private func createDictionaryOfDataAndSaveToFirestore() {
        var dicArray = [String: [String : Any]]()
        var dic = [String : Any]()
        
        finalData = finalData.filter { !$0.isEmpty }
        
        for (row, rowData) in finalData.enumerated() {
            dic = [String : Any]()
            for (col, colData) in rowData.enumerated() {
                dic["cell\(col)"] = colData.value
            }
            dicArray["\(fileName!)ROW\(row)"] = dic
        }
        //print(dicArray)
        saveToDatabase(dicArray)
    }
    
    private func saveToDatabase(_ dicArray: [String: [String : Any]]) {
        for num in (0..<dicArray.count) {
            db.collection(fileName!).document("\(fileName!)ROW\(num)").setData(dicArray["\(fileName!)ROW\(num)"]!)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            Utility.hideLoading()
            Utility.setHomeControllerAsRootViewController()
        }
    }
}


