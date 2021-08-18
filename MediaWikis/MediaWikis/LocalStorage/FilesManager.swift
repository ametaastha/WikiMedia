//
//  FileManager.swift
//  MediaWikis
//
//  Created by Astha Ameta on 18/08/21.
//

import Foundation

class FilesManager {
    enum Error: Swift.Error {
        case fileAlreadyExists
        case invalidDirectory
        case writingFailed
        case fileNotExists
        case readingFailed
        
    }
    let fileManager: FileManager
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    func save(fileNamed: String, data: Data) throws {
        guard let url = makeURL(forFileNamed: fileNamed) else {
            throw Error.invalidDirectory
        }
        print("FilePath\(url)")
        if fileManager.fileExists(atPath: url.absoluteString) {
            throw Error.fileAlreadyExists
        }
        do {
            try data.write(to: url)
        } catch {
            debugPrint(error)
            throw Error.writingFailed
        }
    }
    private func makeURL(forFileNamed fileName: String) -> URL? {
        guard let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(fileName)
    }
    
    
    func read(fileNamed: String) throws -> Data {
           guard let url = makeURL(forFileNamed: fileNamed) else {
               throw Error.invalidDirectory
           }
        let filePath = url.path
        guard fileManager.fileExists(atPath: filePath) else {
               throw Error.fileNotExists
           }
           do {
               return try Data(contentsOf: url)
           } catch {
               debugPrint(error)
               throw Error.readingFailed
           }
       }
    
}
