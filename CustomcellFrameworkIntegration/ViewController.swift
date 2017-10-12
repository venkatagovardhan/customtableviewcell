//
//  ViewController.swift
//  CustomcellFrameworkIntegration
//
//  Created by venkatagovardhan on 8/30/17.
//  Copyright © 2017 venkatagovardhan. All rights reserved.
//

import UIKit
import customcellFramework
class ViewController: UITableViewController {
    let CELL_IDENTIFIER =  "CellID"
    let dataModel  = Datamodel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(CustomCell.self, forCellReuseIdentifier: CELL_IDENTIFIER)
        dataModel.delegate = self
        
        dataModel.fetchDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.dataModel.cellModelArray?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_IDENTIFIER, for: indexPath)  as! CustomCell
        if ((self.dataModel.cellModelArray?.count) == 0){
            return cell
        }else{
            if let dataForIndex = self.dataModel.cellModelArray?[indexPath.row]{
                guard let area = dataForIndex.area,
                    let name = dataForIndex.name,
                    let capital = dataForIndex.capital,
                    let largestCity = dataForIndex.largestCity else {
                        
                        return cell
                }
                
                cell.AreaLabelText(area)
                cell.NameLabelText(name)
                cell.CapitalLabelText(capital)
                cell.LargestCityLabelText(largestCity)
                
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}


extension ViewController: DataModelDelegate{
    
    func dataParsingCompleted()
    {
        if ((self.dataModel.cellModelArray?.count) != nil) {
                        DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
