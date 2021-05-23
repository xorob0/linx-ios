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
                handleFile(data: data as! Data, handleLink: {url in
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                    pasteboard.setString(url.absoluteString, forType: NSPasteboard.PasteboardType.string);
                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                })
            }
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }
}
