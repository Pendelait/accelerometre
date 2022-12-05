//
//  logRequest.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 17/11/2022.
//

import Foundation
import Alamofire

class AppRequest : NSObject {
    
    static var shared = AppRequest()
    
    let baseLink = "http://api.tambolun.fr:8000/"
    
    
    
    func requestPostLog(logs : [log]){
        let endpoint = "log/addLog/"
        
        logs.forEach{ item in
            print(item.dictionary)
            AF.request(baseLink+endpoint,method: .post, parameters: item.dictionary).response{ AFResp in
                guard let response = AFResp.data else {return}
                print(response.toString())
            }
        }
        
    }
}


