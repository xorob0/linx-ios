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
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        
        let contentType = kUTTypeData as String
        for provider in attachments {
            provider.loadItem(forTypeIdentifier: contentType,
                              options: nil) { [unowned self] (data, error) in
                guard error == nil else { return }
                if let url = data as? URL,
                   let imageData = try? Data(contentsOf: url) {
                    if let suite = UserDefaults(suiteName: "group.xorob0.linxshare") {
                        if let url = suite.string(forKey: "url") {
                            AF.upload(imageData, to: "\(url)/upload", method: .put).response { response in
                                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                    let pasteboard = UIPasteboard.general
                                    pasteboard.string = utf8Text
                                    extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                                }
                            }
                        }
                    }

                } else {
                    fatalError("Impossible to save image")
                }
            }
        }
    }
}
