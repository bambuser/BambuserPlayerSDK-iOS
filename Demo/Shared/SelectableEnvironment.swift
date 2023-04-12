//
//  SelectableEnvironment.swift
//  
//
//  Created by Pontus Jacobsson on 2023-03-29.
//

import BambuserPlayerSDK

enum SelectableEnvironment: String, CaseIterable {
    case auto
    case global
    case eu
    case other

    init(environment: BambuserEnvironment?) {
        switch environment {
        case .global: self = .global
        case .eu: self = .eu
        case .other: self = .other
        default: self = .auto
        }
    }

    func environment(otherName: String? = nil) -> BambuserEnvironment? {
        switch self {
        case .auto: return nil
        case .global: return .global
        case .eu: return .eu
        case .other:
            if let otherName {
                return .other(name: otherName)
            } else {
                return nil
            }
        }
    }
}
