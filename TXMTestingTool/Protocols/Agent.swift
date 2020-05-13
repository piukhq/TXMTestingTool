//
//  Agent.swift
//  TXMTestingTool
//
//  Created by Jack Rostron on 11/05/2020.
//  Copyright © 2020 Bink. All rights reserved.
//

import Foundation

protocol Agent: PrettyNamedObject {
    var slug: String { get }
    var prettyName: String { get }
}
