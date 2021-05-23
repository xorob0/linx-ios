//
//  ShareViewController.swift
//  ShareExtension(MacOS)
//
//  Created by Tim Simon on 23/05/2021.
//

import Cocoa
import Alamofire


class ShareViewController: NSViewController {
    
    override var nibName: NSNib.Name? {
        return NSNib.Name("ShareViewController")
    }
    
    override func loadView() {
        super.loadView()
        send()
    }
    
    func send() {
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        let contentType = kUTTypeData as String
        for provider in attachments {
            provider.loadItem(forTypeIdentifier: contentType,
                              options: nil) { [unowned self] (data, error) in
                    handleSharedFile(data: data as! Data)
            }
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }
    
    private func handleSharedFile(data : Data) {
        if let suite = UserDefaults(suiteName: "group.xorob0.linxshare") {
            if let url = suite.string(forKey: "url") {
                AF.upload(data, to: "\(url)/upload", method: .put).response { response in
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let pasteboard = NSPasteboard.general
                        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                        pasteboard.setString(utf8Text, forType: NSPasteboard.PasteboardType.string);
                        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                    }
                }
            }
        }
    }
}
