//
//  SecureUnarchiveTransformer.swift
//  Moodbud
//
//  Created by Lulu on 7/3/23.
//

import Foundation
import UIKit

@objc(SecureUnarchiveTransformer)
final class SecureUnarchiveTransformer: NSSecureUnarchiveFromDataTransformer {
    
    override static var allowedTopLevelClasses: [AnyClass] {
        return [UIImage.self, /* Add any other classes that can be stored in diaryImage */]
    }
    
    public override static func transformedValueClass() -> AnyClass {
        return NSData.self
    }
    
}
