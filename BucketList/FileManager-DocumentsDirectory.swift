//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Jacob and Shalise on 5/11/22.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
