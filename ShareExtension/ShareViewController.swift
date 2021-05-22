import UIKit
import MobileCoreServices
import Alamofire


@objc(ShareExtensionViewController)
class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.handleSharedFile()
    }
    private func handleSharedFile() {
        // extracting the path to the URL that is being shared
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        
        let contentType = kUTTypeData as String
        for provider in attachments {
            provider.loadItem(forTypeIdentifier: contentType,
                              options: nil) { [unowned self] (data, error) in
                // Handle the error here if you want
                guard error == nil else { return }
                
                if let url = data as? URL,
                   let imageData = try? Data(contentsOf: url) {
                    if let suite = UserDefaults(suiteName: "group.xorob0.linxshare") {
                        if let stringOne = suite.string(forKey: "url") {
                            AF.upload(imageData, to: "\(stringOne)/upload", method: .put).response { response in
                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                    let pasteboard = UIPasteboard.general
                                    pasteboard.string = utf8Text
                                    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                                }
                            }
                        }
                    }

                } else {
                    // Handle this situation as you prefer
                    fatalError("Impossible to save image")
                }
            }
        }
    }
}
