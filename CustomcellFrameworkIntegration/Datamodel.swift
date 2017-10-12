//
//  Datamodel.swift
//  CustomcellFrameworkIntegration
//
//  Created by venkatagovardhan on 8/30/17.
//  Copyright © 2017 venkatagovardhan. All rights reserved.
//

import Foundation
import Foundation

struct CellModel {
    var country:String?
    var name:String?
    var abbr:String?
    var area:String?
    var largestCity:String?
    var capital:String?
}

protocol DataModelDelegate {
    func dataParsingCompleted()
}

class Datamodel: NSObject
{
    let REQUEST_URL = "http://services.groupkt.com/state/get/USA/"
    
    var delegate : DataModelDelegate!
    var cellModelArray :[CellModel]? = []
    func fetchDataFromServer() {
        guard let requestURL = URL(string: REQUEST_URL) else {return}
        let fetchService = LBBVAFetchService()
        fetchService.delegate = self
        fetchService.fetchDataFrom(requestURL)
        
    }
}

extension Datamodel:FetchServiceDelegate
{
    func didRecieveResponse(withData data:Data?)
    {
        do{
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
            print(json)
            if  let restResponse = json["RestResponse"] as?
            
            [String:AnyObject]{
                
                if let results = restResponse["result"] as?[[String: AnyObject]]{
                    for result in results{
                        var cellModel = CellModel()
                        if let country = result["country"],
                            let name = result["name"],
                            let abbr = result["abbr"],
                            let largestCity = result["largest_city"],
                            let capital = result["capital"] , let area = result["area"]{
                            cellModel.country = country as? String
                            cellModel.name = name as? String
                            cellModel.abbr = abbr as? String
                            cellModel.largestCity = largestCity as? String
                            cellModel.capital = capital as? String
                            let areaString = area as? String
                            cellModel.area = areaString?.convertAreaInKmSToMilesS()
                            
                        }
                        self.cellModelArray?.append(cellModel)
                    }
                }
            }
            
        }catch{
            print(error)
        }
        self.delegate.dataParsingCompleted()
    }
}

protocol FetchServiceDelegate {
    func didRecieveResponse(withData data:Data?)
}

class LBBVAFetchService: NSObject {
    
    var delegate:FetchServiceDelegate!
    
    func fetchDataFrom(_ url:URL) {
        
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error ?? "Error Fetching data")
            } else {
                if let data = data{
                    self.delegate.didRecieveResponse(withData: data)
                }
            }
            }.resume()
    }
}



extension String{
    func convertAreaInKmSToMilesS() -> String {
        let componentsArray = self.components(separatedBy: "S")
        let value:Int = Int(componentsArray.first!)!
        let milesValue = Int(0.621371*Double(value))
        return "\(milesValue)SM"
    }
}
