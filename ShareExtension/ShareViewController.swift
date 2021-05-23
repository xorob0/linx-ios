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
                   let data = try? Data(contentsOf: url) {
                    handleFile(data: data) { url in
                        let pasteboard = UIPasteboard.general
                        pasteboard.string = url.absoluteString
                        extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
                    }
                }
            }
        }
    }
}
