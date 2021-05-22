//
//  OpenFile.swift
//  LinxShare
//
//  Created by Tim Simon on 22/05/2021.
//   based on: Aaron Wright's post:
//   https://medium.com/better-programming/importing-and-exporting-files-in-swiftui-719086ec712
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct OpenFile: FileDocument {

    static var readableContentTypes: [UTType] { [.plainText] }

    var input: String

    init(input: String) {
        self.input = input
    }

    init(configuration: FileDocumentReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        input = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: input.data(using: .utf8)!)
    }

}
