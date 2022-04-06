//
//  UUID.swift
//  TXMTestingTool
//
//  Created by Michal Jozwiak on 06/04/2022.
//  Copyright © 2022 Bink. All rights reserved.
//

import Foundation

extension UUID{
    var base64uuid: String {
        guard let uuid = UUID().uuidString.data(using: .utf8)?.base64EncodedString() else {
            // This should never happen as we trust .uuidString to always return a valid utf8 string.
            fatalError("Failed to generate base64-encoded UUID string")
        }
        return uuid
    }
}
