 import UIKit
import WebKit

class ViewController: UIViewController {
    enum Method: String {
        case getAccounts
        case signTransaction
        case approveTransaction
    }

    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: Method.getAccounts.rawValue)
        configuration.userContentController.add(self, name: Method.signTransaction.rawValue)
        configuration.userContentController.add(self, name: Method.approveTransaction.rawValue)

        let view = WKWebView(frame: self.view.frame, configuration: configuration)
        view.scrollView.isScrollEnabled = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.webView)

        let request = URLRequest(url: URL(string: "http://192.168.1.91:8000")!)
        self.webView.load(request)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.webView.evaluateJavaScript("javascript:SOFA.initialize(true);") { jsReturnValue, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let newCount = jsReturnValue as? Int {
                    print("Returned value: \(newCount)")
                } else {
                    print("No return from JS")
                }
            }
        }
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let method = Method(rawValue: message.name) else { return print("failed \(message.name)") }
        switch method {
        case .getAccounts: break
        case .signTransaction: break
        case .approveTransaction: break
        }

        print("userContentController \(userContentController)")
        print("message.name \(message.name)")
        print("message.body \(message.body)")
        print("---")
   }
}
