//
//  ContentView.swift
//  Shared
//
//  Created by Tim Simon on 22/05/2021.
//

import SwiftUI
import Alamofire

struct HTTPBinResponse: Decodable { let url: String }

struct ContentView: View {
    @State private var url: String = "https://linx.gneee.tech"
    @State private var isImporting: Bool = false
    @State private var document: FileDocument = OpenFile(input: "")
    @State private var links: [URL] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Enter Linx URL", text: $url)
            Button(action: {
                isImporting = true
            }) {
                Image(systemName: "square.and.arrow.down")
                    .font(.largeTitle)
                    .foregroundColor(.red)
            }
            
            ForEach(links, id: \.self) { link in
                Link(link.absoluteString, destination: link)        }

            
        }        .padding()
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [.image],
                allowsMultipleSelection: true
            ) { result in
                do {
                    let fileUrls = try result.get()
                    
                    for fileUrl in fileUrls {
                        let data = try Data(contentsOf: fileUrl)
                        
                        AF.upload(data, to: "\(url)/upload", method: .put).response { response in
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                links.append(URL(string: utf8Text.trimmingCharacters(in: CharacterSet.newlines))!)
                                debugPrint(utf8Text)
                            }
                        }
                    }
                    
                } catch {
                    // Handle failure.
                    print("Unable to read file contents")
                    print(error.localizedDescription)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
