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

class VitaDecoder: JSONDecoder {
    override init() {
        super.init()
        // swiftlint:disable force_cast
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.userInfo[CodingUserInfoKey.managedObjectContext] =
            appDelegate.persistentContainer.viewContext
    }
}
