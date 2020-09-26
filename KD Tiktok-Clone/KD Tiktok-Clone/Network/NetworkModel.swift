//
//  NetworkModel.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/20/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation

class NetworkModel: NSObject {
    /// Firebase call successfully returns data
    typealias Success = (Any) -> Void
    /// Firebase call fails to return data
    typealias Failure = (Error) -> Void
}
