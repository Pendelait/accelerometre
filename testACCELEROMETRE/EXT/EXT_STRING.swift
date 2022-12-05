//
//  EXT_STRING.swift
//  testACCELEROMETRE
//
//  Created by AVETISSIAN VAHE on 30/11/2022.
//

import Foundation

extension String {
    var isNumber: Bool {
        let digitsCharacters = CharacterSet(charactersIn: "0123456789")
        return CharacterSet(charactersIn: self).isSubset(of: digitsCharacters)
    }
}
