//
//  EXT_DATA.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 23/11/2022.
//

import Foundation

extension Data {
    func toString() -> String{
        return String(data: self, encoding: .utf8) ?? "Donnée erroné"
    }
}
