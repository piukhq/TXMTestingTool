//
//  NSStoryboard.swift
//  TXMTestingTool
//
//  Created by Jack Rostron on 07/04/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import AppKit

extension NSStoryboard {
    static func fromMain<T>(loadController controller: T.Type) -> T? {
        let identifier = String(describing: T.self)
        return NSStoryboard.main?.instantiateController(withIdentifier: identifier) as? T
    }
}
