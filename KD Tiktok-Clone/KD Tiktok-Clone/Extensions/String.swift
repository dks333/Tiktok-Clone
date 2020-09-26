//
//  String.swift
//  KD Tiktok-Clone
//
//  Created by Sam Ding on 9/23/20.
//  Copyright © 2020 Kaishan. All rights reserved.
//

import Foundation

extension String{
    static func format(decimal:Float, _ maximumDigits:Int = 1, _ minimumDigits:Int = 1) ->String? {
        let number = NSNumber(value: decimal)
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = maximumDigits
        numberFormatter.minimumFractionDigits = minimumDigits
        return numberFormatter.string(from: number)
    }
    
}
