//
//  Extensions.swift
//  SwiftDigest
//
//  Created by Brent Royal-Gordon on 8/25/14.
//  Copyright (c) 2014 Groundbreaking Software. All rights reserved.
//

import Foundation

internal extension Data {
    var bufferPointer: UnsafeBufferPointer<UInt8> {
        return UnsafeBufferPointer<UInt8>(start: (self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count), count: self.count)
    }
}

internal extension UInt8 {
    fileprivate static let allHexits: [Character] = Array("0123456789abcdef".characters)
    
    func toHex() -> String {
        let nybbles = [ self >> 4, self & 0x0F ]
        let hexits = nybbles.map { nybble in UInt8.allHexits[Int(nybble)] }
        return String(hexits)
    }
}
