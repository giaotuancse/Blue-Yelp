//
//  UnitConvertUtils.swift
//  Yelp
//
//  Created by Giao Tuan on 11/22/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import Foundation

public class UnitConvertUtils {
    
    public static func MileToMeter(mile : Float) -> Int{
        return  Int(mile*1609.344)
    }

}