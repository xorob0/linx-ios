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
    @State private var suite = UserDefaults(suiteName: "group.xorob0.linxshare")!
    @State private var url: String =  UserDefaults(suiteName: "group.xorob0.linxshare")?.string(forKey: "url") ?? "https://linx.com"
    @State private var isImporting: Bool = false
    @State private var document: FileDocument = OpenFile(input: "")
    @State private var links: [URL] = []
    
    
    
    var body: some View {
        
        let binding = Binding<String>(get: {
            self.url
        }, set: {
            suite.set("\($0)/upload", forKey: "url")
            self.url = $0
        })
        VStack(alignment: .leading) {
            TextField("Enter Linx URL", text: binding)
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
                    handleFile(data: data, handleLink: {url in
                        links.append(url)
                    })
                }
                
            } catch {
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
