//
//  OwnerServices.swift
//  GV24
//
//  Created by admin on 6/9/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OwnerServices: APIService {
    
    static let sharedInstance = OwnerServices()
    
    func getOwnersList(url: String, param: Parameters, header: HTTPHeaders, completion: @escaping(([Owner]?, Error?) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
                case .success(let value):
                    let json = JSON(value).dictionary
                    var list: [Owner] = []
                    if let status = json?["status"], status == true {
                        if let results = json?["data"]?.array {
                            for item in results {
                                let owner = Owner(json: item["_id"])
                                if let times = item["times"].arrayObject as? [String] {
                                    owner.workTime.append(contentsOf: times)
                                }
                                list.append(owner)
                            }
                            completion(list, nil)
                        }
                    }
                    else {
                        completion(nil,nil)
                    }
                    break;
                case .failure(let err):
                    var error = Error()
                    error.errorContent = err.localizedDescription
                    completion(nil, error)
                    break;
            }
        }
    }
    
    func getTaskOfOwner(url: String, param:Parameters, header: HTTPHeaders, completion: @escaping(([Work]?, Error?) -> ())) {
        Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: header).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let json = JSON(value).dictionary
                var workList:[Work] = []
                if let status = json?["status"], status == true {
                    if let list = json?["data"]?["docs"] {
                        for item in list {
                            let work = Work(json: item.1)
                            workList.append(work)
                        }
                        completion(workList,nil)
                    }
                }
                else {
                    completion(nil, nil)
                }
                break;
            case .failure(let error):
                completion(nil, (error as! Error))
                break;
            }
        }
    }
}
