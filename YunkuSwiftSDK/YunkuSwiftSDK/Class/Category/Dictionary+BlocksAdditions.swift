//
//  DictonaryExt.swift
//  YunkuSwiftSDK
//
//  Created by Brandon on 15/6/3.
//  Copyright (c) 2015年 goukuai. All rights reserved.
//

import Foundation

extension Dictionary {
    init(_ elements: [Element]){
        self.init()
        for (k, v) in elements {
            self[k] = v
        }
    }
    
    func map<U>(_ transform: (Value) -> U) -> [Key : U] {
        return Dictionary<Key, U>(self.map({ (key, value) in (key, transform(value)) }))
    }
    
    func map<T : Hashable, U>(_ transform: (Key, Value) -> (T, U)) -> [T : U] {
        return Dictionary<T, U>(self.map(transform))
    }
    
    func filter(_ includeElement: (Element) -> Bool) -> [Key : Value] {
        return Dictionary(self.filter(includeElement))
    }
    
    func reduce<U>(_ initial: U, combine: (U, Element) -> U) -> U {
        return self.reduce(initial, combine: combine)
    }
}

