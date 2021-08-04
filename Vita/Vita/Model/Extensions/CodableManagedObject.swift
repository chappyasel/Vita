//
//  CodableManagedObject.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import Foundation
import UIKit

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

class VJSONDecoder: JSONDecoder {
    override init() {
        super.init()
        self.userInfo[CodingUserInfoKey.managedObjectContext] =
            VCoreData.shared.persistentContainer.viewContext
        self.dateDecodingStrategy = .iso8601
    }
}
