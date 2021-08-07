//
//  Serialization.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import Foundation
import UIKit

class VEncoder: JSONEncoder {
    override init() {
        super.init()
        self.dateEncodingStrategy = .iso8601
    }
}

class VDecoder: JSONDecoder {
    override init() {
        super.init()
        self.dateDecodingStrategy = .iso8601
    }
}
