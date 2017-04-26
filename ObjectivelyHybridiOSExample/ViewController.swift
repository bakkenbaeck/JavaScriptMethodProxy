 import UIKit
import WebKit

class ViewController: UIViewController {
    lazy var webView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(self, name: "SOFA")

        let view = WKWebView(frame: self.view.frame, configuration: configuration)
        view.scrollView.isScrollEnabled = true
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.webView)

        let path = Bundle.main.path(forResource: "index", ofType: "html")!
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)
        self.webView.load(request)
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if let sentData = message.body as? [String: Any] {
            if let count = sentData["count"] as? Int {
                self.webView.evaluateJavaScript("storeAndShow(\(count + 1))") { jsReturnValue, error in
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
}
